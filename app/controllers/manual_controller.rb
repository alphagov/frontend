class ManualController < ContentItemsController
  include Cacheable

  layout "manual"

  def show
    @presenter = ManualPresenter.new(content_item, request)
  end

  def manual_updates
    @presenter = ManualUpdatesPresenter.new(content_item, request)
  end

  def section
    @presenter = ManualSectionPresenter.new(content_item, request)
  end
end
