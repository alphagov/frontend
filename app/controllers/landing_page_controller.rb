class LandingPageController < ContentItemsController
  def content_item_slug
    request.path
  end

  def content_item
    @content_item ||= ContentItemFactory.build(fake_data)
  end

  def fake_data
    {
      "base_path" => "/landing-page",
      "title" => "",
      "description" => "",
      "locale" => "en",
      "document_type" => "landing_page",
      "schema_name" => "landing_page",
      "publishing_app" => "whitehall",
      "rendering_app" => "frontend",
      "update_type" => "major",
      "details" => {},
      "routes" => [
        {
          "type" => "exact",
          "path" => "/landing-page",
        },
      ],
    }
  end
end
