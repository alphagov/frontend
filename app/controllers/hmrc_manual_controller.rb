class HmrcManualController < ContentItemsController
  include Cacheable

  layout "manual"

  def show
    @presenter = HmrcManualPresenter.new(content_item)
  end

  def updates
    @presenter = HmrcManualUpdatesPresenter.new(content_item)
  end

  def section
    @presenter = HmrcManualSectionPresenter.new(content_item)
  end
end
