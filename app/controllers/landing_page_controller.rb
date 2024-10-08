class LandingPageController < ContentItemsController
  slimmer_template "gem_layout_full_width"

  def download
    send_file(Rails.root.join("lib/data/landing_page_content_items/chart_data/chart_one.csv"), type: "text/csv", disposition: "attachment")
  end

private

  # SCAFFOLDING: can be removed when basic content items are available
  # from content-store
  def request_content_item(_base_path)
    GdsApi.content_store.content_item(request.path).to_h
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
