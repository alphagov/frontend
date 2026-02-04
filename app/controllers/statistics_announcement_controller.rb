class StatisticsAnnouncementController < ContentItemsController
  include Cacheable

  def show
    @presenter = StatisticsAnnouncementPresenter.new(content_item)
  end
end
