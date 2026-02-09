class ManualController < ContentItemsController
  include Cacheable

  def show
    @presenter = ManualPresenter.new(content_item)
  end

  def manual_updates
    @presenter = ManualUpdatesPresenter.new(content_item)
  end

  def section
    @presenter = ManualSectionPresenter.new(content_item)
  end
end
