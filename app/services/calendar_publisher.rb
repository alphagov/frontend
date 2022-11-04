class CalendarPublisher
  def initialize(calendar, slug: nil)
    @calendar = calendar
    @slug = slug
  end

  def publish
    GdsApi.publishing_api.put_content(rendered.content_id, rendered.payload)
    GdsApi.publishing_api.publish(rendered.content_id, nil, { locale: I18n.locale })
    GdsApi.publishing_api.patch_links(rendered.content_id, { links: rendered.links })
  end

private

  def rendered
    @rendered ||= CalendarContentItem.new(@calendar, slug: @slug)
  end
end
