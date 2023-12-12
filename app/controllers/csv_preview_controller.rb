require "csv"

class CsvPreviewController < ApplicationController
  MAXIMUM_COLUMNS = 50
  MAXIMUM_ROWS = 1000

  rescue_from GdsApi::HTTPForbidden, with: :access_limited

  def show
    @asset = GdsApi.asset_manager.asset(params[:id]).to_hash

    return error_410 if @asset["deleted"] || @asset["redirect_url"].present?
    if draft_asset? && !served_from_draft_host?
      redirect_to(Plek.find("draft-assets") + request.path, allow_other_host: true) and return
    end

    parent_document_path = URI(@asset["parent_document_url"]).request_uri
    @content_item = GdsApi.content_store.content_item(parent_document_path).to_hash
    @attachment_metadata = @content_item.dig("details", "attachments").select do |attachment|
      attachment["filename"] == asset_filename
    end

    original_error = nil
    row_sep = :auto

    begin
      csv_preview = CSV.parse(media_download, encoding: encoding(media_download), headers: true, row_sep:)
    rescue CSV::MalformedCSVError => e
      if original_error.nil?
        original_error = e
        row_sep = "\r\n"
        retry
      else
        render :malformed_csv and return
      end
    end

    @csv_rows = csv_preview.to_a.map { |row|
      row.map { |column|
        {
          text: column&.encode("UTF-8"),
        }
      }.take(MAXIMUM_COLUMNS)
    }.take(MAXIMUM_ROWS + 1)
  end

  def access_limited
    render :access_limited, status: :forbidden and return
  end

private

  def asset_path
    request.path.sub("/preview", "").sub(/^\//, "")
  end

  def asset_filename
    asset_path.split("/").last
  end

  def whitehall_media_download
    GdsApi.asset_manager.whitehall_media(asset_path).body
  end

  def media_download
    GdsApi.asset_manager.media(params[:id], params[:filename]).body
  end

  def encoding(media)
    @encoding ||= if utf_8_encoding?(media)
                    "UTF-8"
                  elsif windows_1252_encoding?(media)
                    "windows-1252"
                  else
                    raise FileEncodingError, "File encoding not recognised"
                  end
  end

  def utf_8_encoding?(media)
    media.force_encoding("utf-8").valid_encoding?
  end

  def windows_1252_encoding?(media)
    media.force_encoding("windows-1252").valid_encoding?
  end

  def draft_asset?
    @asset["draft"] == true
  end

  def served_from_draft_host?
    request.hostname == URI.parse(Plek.find("draft-assets")).hostname
  end
end
