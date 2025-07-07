class ServiceManualGuide < ContentItem
  include Updatable

  def content_owners
    linked("content_owners")
  end

  def parent
    linked("parent").first
  end

  def topic
    linked("service_manual_topics").first
  end
end
