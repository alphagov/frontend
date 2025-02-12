class ServiceManualPresenter < ContentItemPresenter
  attr_reader :content_item

  def initialize(content_item)
    super(content_item)
    @content_item = content_item
  end

  def display_as_accordion?
    groups.count > 2 && visually_collapsed?
  end

  def groups
    linked_items = content_item["links"]["linked_items"]
    topic_groups = Array(content_item["details"]["groups"]).map do |group_data|
      ServiceManualTopicPresenter::TopicGroup.new(group_data, linked_items)
    end
    topic_groups.select(&:present?)
  end
end
