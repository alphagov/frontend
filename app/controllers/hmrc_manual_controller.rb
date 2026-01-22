class HmrcManualController < ContentItemsController
  include Cacheable

  def show
    @presenter = HmrcManualPresenter.new(content_item)
  end

  def section
    @presenter = HmrcManualSectionPresenter.new(content_item)
  end
end
