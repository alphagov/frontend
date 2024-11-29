require "govuk_schemas"
require "gds_api/test_helpers/search"

module SearchHelpers
  include GdsApi::TestHelpers::Search

  def stub_taxon_search_results(slug = "doc-one")
    title = slug.tr("-", " ").capitalize

    results = [
      {
        "title" => title,
        "link" => "/#{slug}",
        "description" => "#{title} description",
        "format" => "press_release",
        "public_timestamp" => Time.zone.local(2024, 1, 1, 10, 24, 0),
      },
    ]

    body = {
      "results" => results,
      "start" => "0",
      "total" => results.size,
    }

    stub_any_search.to_return("body" => body.to_json)
  end
end
