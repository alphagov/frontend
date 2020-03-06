require "gds_api/publishing_api_v2"

namespace :publishing_api do
  desc "Publish special routes such as the homepage"
  task publish_special_routes: :environment do
    publishing_api = GdsApi::PublishingApi.new(
      Plek.new.find("publishing-api"),
      bearer_token: ENV["PUBLISHING_API_BEARER_TOKEN"] || "example",
    )

    logger = Logger.new(STDOUT)

    publisher = SpecialRoutePublisher.new(
      logger: logger,
      publishing_api: publishing_api,
    )

    SpecialRoutePublisher.routes.each do |route_type, routes_for_type|
      routes_for_type.each do |route|
        publisher.publish(route_type, route)
      end
    end

    HomepagePublisher.publish!(publishing_api, logger)
  end

  BREXIT_EU_FUNDING_ROUTES = [
    {
      content_id: "fe29ccb9-99c5-4727-a64e-57aa4a44ab81",
      base_path: "/brexit-eu-funding/who-should-we-contact-about-the-grant-award",
    },
    {
      content_id: "7028ad9f-1a3e-4921-b0f1-d7085c7daa1b",
      base_path: "/brexit-eu-funding/organisation-type",
    },
    {
      content_id: "9d76509b-7a8d-42e0-aa1a-300616dbbed8",
      base_path: "/brexit-eu-funding/organisation-details",
    },
    {
      content_id: "2d52b223-2fae-4a43-9f15-af5c36d9883d",
      base_path: "/brexit-eu-funding/do-you-have-a-company-or-charity-registration-number",
    },
    {
      content_id: "c422b6e0-4f0c-460b-9452-6519eefbef26",
      base_path: "/brexit-eu-funding/do-you-have-a-grant-agreement-number",
    },
    {
      content_id: "48b4c601-7c64-4c42-a8db-8b769b51a8fd",
      base_path: "/brexit-eu-funding/what-programme-do-you-receive-funding-from",
    },
    {
      content_id: "72969d5e-832f-4e16-b9cb-0c9ab0fad3e4",
      base_path: "/brexit-eu-funding/project-details",
    },
    {
      content_id: "097322ee-d651-47e5-b390-cb72b4661b94",
      base_path: "/brexit-eu-funding/does-the-project-have-partners-or-participants-outside-the-uk",
    },
    {
      content_id: "dbd71f0f-1014-423e-b786-10ec53cd6845",
      base_path: "/brexit-eu-funding/check-your-answers",
    },
    {
      content_id: "08d52d2b-3b89-4c2c-871c-7b8b2f1c92f1",
      base_path: "/brexit-eu-funding/confirmation",
    },
  ].freeze

  desc "Unpublish Brexit EU funding form"
  task unpublish_brexit_eu_funding: :environment do
    BREXIT_EU_FUNDING_ROUTES.each do |route|
      GdsApi.publishing_api_v2.unpublish(
        route[:content_id],
        type: "redirect",
        allow_draft: false,
        redirects: [
          {
            path: route[:base_path],
            type: "exact",
            segments_mode: "preserve",
            destination: "/guidance/register-as-an-organisation-getting-funding-directly-from-the-eu",
          },
        ],
      )
    end
  end
end
