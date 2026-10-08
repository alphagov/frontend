class StatisticsAnnouncementController < ContentItemsController
  include Cacheable

  def show
    @content_item_presenter = StatisticsAnnouncementPresenter.new(content_item)
  end
end
