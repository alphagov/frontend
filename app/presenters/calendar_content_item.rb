# Renders a calendar for the publishing-api.
class CalendarContentItem
  GDS_ORGANISATION_ID = "af07d5a5-df63-4ddc-9383-6a666845ebe9".freeze

  attr_reader :calendar

  def initialize(calendar, slug: nil)
    @calendar = calendar
    @slug = slug
  end

  def base_path
    "/#{@slug || calendar.slug}"
  end

  def update_type
    "minor"
  end

  delegate :content_id, to: :calendar

  def payload
    {
      title: calendar.title,
      description: calendar.description,
      base_path:,
      document_type: "calendar",
      schema_name: "calendar",
      publishing_app: "frontend",
      rendering_app: "frontend",
      locale: I18n.locale.to_s,
      details: {
        body: calendar.body,
      },
      public_updated_at: Time.zone.now.rfc3339,
      routes: [
        { type: "prefix", path: base_path },
        { type: "exact", path: "#{base_path}.json" },
      ],
      update_type:,
    }
  end

  def links
    {
      "primary_publishing_organisation": [GDS_ORGANISATION_ID],
    }
  end
end
