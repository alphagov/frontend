class CsvPreviewController < ApplicationController
  def show
    legacy_url_path = request.path.sub("/preview", "").sub(/^\//, "")
    @asset = GdsApi.asset_manager.whitehall_asset(legacy_url_path).to_hash

    @content_item = GdsApi.content_store.content_item(@asset["parent_document_url"].sub("https://www.gov.uk", "")).to_hash

    @attachment_metadata = @content_item.dig("details", "attachments").select do |attachment|
      attachment["url"] =~ /#{legacy_url_path}$/
    end
  end
end
