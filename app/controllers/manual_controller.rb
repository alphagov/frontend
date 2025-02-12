class ManualController < ContentItemsController
  def show
    @topics = sorted_topics
  end

  private

  def sorted_topics
    (@content_item.links["children"] || []).sort_by { |topic| topic["title"] }
  end
end
