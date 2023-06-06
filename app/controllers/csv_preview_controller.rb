class CsvPreviewController < ApplicationController
  def show
    legacy_url_path = request.path.sub("/preview", "").sub(/^\//, "")
    @asset = GdsApi.asset_manager.whitehall_asset(legacy_url_path).to_hash

    parent_document_path = URI(@asset["parent_document_url"]).request_uri
    @content_item = GdsApi.content_store.content_item(parent_document_path).to_hash

    @attachment_metadata = @content_item.dig("details", "attachments").select do |attachment|
      attachment["url"] =~ /#{legacy_url_path}$/
    end
  end
end
