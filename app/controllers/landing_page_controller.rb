class LandingPageController < ContentItemsController
  slimmer_template "gem_layout_full_width"

private

  # SCAFFOLDING: can be removed when basic content items are available
  # from content-store
  def content_item
    @content_item ||= ContentItemFactory.build(old_scaffolding_content_item)
  end

  # SCAFFOLDING: can be removed when basic content items are available
  # from content-store
  def old_scaffolding_content_item
    ContentItemLoaderGdsApi.content_store.content_item(request.path).to_h
  rescue StandardError
    fake_data
  end

  # SCAFFOLDING: can be removed when basic content items are available
  # from content-store
  def fake_data
    {
      "base_path" => request.path,
      "title" => "Landing Page",
      "description" => "A landing page example",
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
          "path" => request.path,
        },
      ],
    }
  end
end
