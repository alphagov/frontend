require "gds_api/publishing_api/special_route_publisher"

class SpecialRoutePublisher
  def initialize(publisher_options)
    @publisher = GdsApi::PublishingApi::SpecialRoutePublisher.new(publisher_options)
  end

  def publish(route_type, route)
    @publisher.publish(
      route.merge(
        format: "special_route",
        publishing_app: "frontend",
        rendering_app: "frontend",
        type: route_type,
        public_updated_at: Time.zone.now.iso8601,
        update_type: "major",
      ),
    )
  end

  def self.routes
    {
      exact: [
        {
          content_id: "caf90fb7-11e3-4f8e-9a5d-b83283c91533",
          base_path: "/tour",
          title: "GOV.UK introductory page",
          description: "A description of the various sections of GOV.UK and their uses.",
        },
        {
          content_id: "3c7060f7-9efa-47be-bd36-0326f3fa4f04",
          base_path: "/help",
          title: "Help using GOV.UK",
          description: "Find out about GOV.UK, including the use of cookies, accessibility of the site, the privacy notice and terms and conditions of use.",
          links: {
            ordered_related_items: %w[58b05bc2-fde5-4a0b-af73-8edc532674f8], # /contact
          },
        },
        {
          content_id: "a4d4e755-3d75-4b19-b120-a638a6d79ba8",
          base_path: "/help/ab-testing",
          title: "A/B testing on GOV.UK",
          description: "This page is being used internally by GOV.UK to make sure A/B testing works.",
        },
        {
          content_id: "220f39ad-d4ad-4b0c-9d40-6c417a1341c0",
          base_path: "/help/cookies",
          title: "Cookies on GOV.UK",
          description: "You can choose which cookies you're happy for GOV.UK to use.",
        },
        {
          content_id: "3c991cea-cdee-4e58-b8d1-d38e7c0e6327",
          base_path: "/random",
          title: "GOV.UK random page",
        },
        {
          content_id: "9a86495d-663f-46f8-b4ce-fc9153579338",
          base_path: "/roadmap",
          title: "GOV.UK Roadmap",
          description: "This is GOV.UK's current roadmap. We plan to update it again in the new financial year.",
        },
      ],
      prefix: [
        {
          content_id: "622fda2b-5fa6-4c84-bc3b-22cd3ff08828",
          base_path: "/find-local-council",
          title: "Find your local council",
          description: "Find your local authority in England, Wales, Scotland and Northern Ireland",
        },
      ],
    }
  end
end
