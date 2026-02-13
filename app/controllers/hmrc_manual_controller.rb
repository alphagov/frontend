class HmrcManualController < ContentItemsController
  include Cacheable

  def show; end

  def section
    @presenter = HmrcManualSectionPresenter.new(content_item)
  end
end
