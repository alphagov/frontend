module HomepagePublisher
  CONTENT_ID = "f3bbdec2-0e62-4520-a7fd-6ffd5d36e03a".freeze
  GDS_ORGANISATION_CONTENT_ID = "af07d5a5-df63-4ddc-9383-6a666845ebe9".freeze

  def self.homepage_content_item
    {
      "base_path": "/",
      "document_type": "homepage",
      "schema_name": "homepage",
      "title": "GOV.UK homepage",
      "description": "",
      "locale": "en",
      "details": {},
      "routes": [
        {
          "path": "/",
          "type": "exact",
        },
      ],
      "publishing_app": "frontend",
      "rendering_app": "frontend",
      "public_updated_at": Time.zone.now.iso8601,
      "update_type": "major",
    }
  end

  def self.links
    {
      links: {
        "organisations" => [GDS_ORGANISATION_CONTENT_ID],
        "primary_publishing_organisation" => [GDS_ORGANISATION_CONTENT_ID],
      },
    }
  end

  def self.publish!(publishing_api, logger)
    logger.info("Publishing exact route /, routing to frontend")
    publishing_api.put_content(CONTENT_ID, homepage_content_item)
    publishing_api.publish(CONTENT_ID)
    publishing_api.patch_links(CONTENT_ID, links)
  end
end
