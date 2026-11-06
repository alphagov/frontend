class HmrcManualController < ContentItemsController
  include Cacheable

  layout "header_content_sidebar"

  def show
    @content_item_presenter = HmrcManualPresenter.new(content_item)
  end

  def updates
    @content_item_presenter = HmrcManualUpdatesPresenter.new(content_item)
  end

  def section
    @content_item_presenter = HmrcManualSectionPresenter.new(content_item)
  end
end
