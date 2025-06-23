require "csv"

class CsvPreviewController < ApplicationController
  rescue_from GdsApi::HTTPForbidden, with: :access_limited
  rescue_from CSV::MalformedCSVError, CsvPreviewService::FileEncodingError, with: :malformed_csv

  def show
    @asset = GdsApi.asset_manager.asset(params[:id]).to_hash

    return error_410 if @asset["deleted"] || @asset["redirect_url"].present?
    if draft_asset? && served_from_live_host?
      redirect_to(URI.parse(Plek.find("draft-origin", external: true) + request.path), allow_other_host: true) and return
    end

    parent_document_uri = @asset["parent_document_url"]
    return cacheable_404 unless parent_document_uri

    parent_document_path = URI(parent_document_uri).request_uri
    @content_item = GdsApi.content_store.content_item(parent_document_path).to_hash
    @attachment_metadata = @content_item.dig("details", "attachments").find do |attachment|
      attachment["filename"] == asset_filename
    end

    if @attachment_metadata.nil?
      redirect_to(parent_document_uri, status: :see_other, allow_other_host: true) and return
    end

    return cacheable_404 unless csv_content_type.include?(@attachment_metadata["content_type"])

    @csv_rows, @truncated = CsvPreviewService
      .new(GdsApi.asset_manager.media(params[:id], params[:filename]).body)
      .csv_rows
  end

private

  def access_limited
    render :access_limited, status: :forbidden
  end

  def malformed_csv
    render :malformed_csv
  end

  def asset_path
    request.path.sub("/preview", "").sub(/^\//, "")
  end

  def asset_filename
    asset_path.split("/").last
  end

  def draft_asset?
    @asset["draft"] == true
  end

  def served_from_live_host?
    request.hostname == URI.parse(Plek.website_root).hostname
  end

  def csv_content_type
    ["text/csv", "application/csv"]
  end
end
