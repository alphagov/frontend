class ServiceManualHomepagePresenter < ContentItemPresenter
  def sorted_topics
    content_item.topics.sort_by(&:title).map do |topic|
      {
        link: {
          path: topic.base_path,
          text: topic.title,
        },
        description: topic.description,
      }
    end
  end
end
