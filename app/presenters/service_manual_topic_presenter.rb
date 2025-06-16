class ServiceManualTopicPresenter
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def breadcrumbs
    [
      { title: "Service manual", url: "/service-manual" },
    ]
  end
end
