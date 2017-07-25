module HomepagePublisher
  CONTENT_ID = "f3bbdec2-0e62-4520-a7fd-6ffd5d36e03a".freeze

  def self.homepage_content_item
    {
      "base_path": "/",
      "document_type": "homepage",
      "schema_name": "homepage",
      "title": "GOV.UK homepage",
      "description": "",
      "locale": "en",
      "details": {
      },
      "routes": [
        {
          "path": "/",
          "type": "exact"
        }
      ],
      "publishing_app": "frontend",
      "rendering_app": "frontend",
      "public_updated_at": Time.zone.now.iso8601,
      "update_type": "major",
    }
  end

  def self.publish!(publishing_api, logger)
    logger.info("Publishing exact route /, routing to frontend")
    publishing_api.put_content(CONTENT_ID, homepage_content_item)
    publishing_api.publish(CONTENT_ID)
  end
end
