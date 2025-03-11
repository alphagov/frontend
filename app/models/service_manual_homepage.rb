class ServiceManualHomepage < ContentItem
  def topics
    linked("children")
  end
end
