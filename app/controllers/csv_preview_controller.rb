class CsvPreviewController < ApplicationController
  def show
    legacy_url_path = request.path.sub("/preview", "").sub(/^\//, "")
    @asset = GdsApi.asset_manager.whitehall_asset(legacy_url_path).to_hash
  end
end
