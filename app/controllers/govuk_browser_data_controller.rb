class GovukBrowserDataController < FlexiblePageController
  def show
    render "flexible_page/show"
  end

private

  def set_content_item_and_cache_control
    @content_item = GovukBrowserData.new({ "base_path" => "/govuk-browser-data" })
    @cache_control = nil
  end
end
