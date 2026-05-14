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

  def navigation
    [
      {
        text: "Service Manual",
        href: "/service-manual",
        active: true
      },
      {
        text: "The Service Standard",
        href: "/service-manual/service-standard"
      },
      {
        text: "Communities of Practice",
        href: "/service-manual/communities"
      },
    ]
  end
end
