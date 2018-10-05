require 'gds_api/publishing_api/special_route_publisher'

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
      )
    )
  end

  def self.routes
    {
      exact: [
        {
          content_id: "ffcd9054-ee77-4539-978d-171a60eb4b2a",
          base_path: "/homepage",
          title: "GOV.UK homepage redirect",
          description: "Redirects to /",
        },
        {
          content_id: "dfec39bf-cf04-4e0b-a621-8444372fbf45",
          base_path: "/security.txt",
          title: "security.txt for GOV.UK",
          description: "Provides contact details for GOV.UK to be used by security researchers.",
        },
        {
          content_id: "145f132a-e179-4ced-873e-1c81f2394621",
          base_path: "/.well-known/security.txt",
          title: "security.txt for GOV.UK",
          description: "Provides contact details for GOV.UK to be used by security researchers.",
        },
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
          description: "Find out about GOV.UK, including the use of cookies, accessibility of the site, the privacy policy and terms and conditions of use.",
          links: {
            ordered_related_items: ["58b05bc2-fde5-4a0b-af73-8edc532674f8"] # /contact
          }
        },
        {
          content_id: "a4d4e755-3d75-4b19-b120-a638a6d79ba8",
          base_path: "/help/ab-testing",
          title: "A/B testing on GOV.UK",
          description: "This page is being used internally by GOV.UK to make sure A/B testing works.",
        },
        {
          content_id: "50aa0d27-ea4a-49b7-a1e6-98abd1115f60",
          base_path: "/help.json",
          title: "Help using GOV.UK",
          description: "Find out about GOV.UK, including the use of cookies, accessibility of the site, the privacy policy and terms and conditions of use rendered in JSON format here.",
        },
        {
          content_id: "3c991cea-cdee-4e58-b8d1-d38e7c0e6327",
          base_path: "/random",
          title: "GOV.UK random page",
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
