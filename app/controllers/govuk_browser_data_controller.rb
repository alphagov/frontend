class GovukBrowserDataController < ContentItemsController
  attr_reader :content_presenter

  helper_method :content_presenter

  def index
    @content_presenter = GovukBrowserDataPresenter.new(content_item, view_context)
  end

private

  def set_content_item_and_cache_control
    @content_item = GovukBrowserData.new({ "base_path" => "/govuk-browser-data" })
    @cache_control = nil
  end
end
