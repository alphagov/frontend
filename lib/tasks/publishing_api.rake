namespace :publishing_api do
  desc "Publish special routes such as the homepage"
  task publish_special_routes: :environment do
    logger = Logger.new($stdout)

    publisher = SpecialRoutePublisher.new(
      logger:,
      publishing_api: GdsApi.publishing_api,
    )

    SpecialRoutePublisher.routes.each do |route_type, routes_for_type|
      routes_for_type.each do |route|
        publisher.publish(route_type, route)
      end
    end

    HomepagePublisher.publish!(GdsApi.publishing_api, logger)
  end

  desc "Publish calendars"
  task publish_calendars: :environment do
    %w[bank-holidays when-do-the-clocks-change].each do |calender_name|
      calendar = Calendar.find(calender_name)
      CalendarPublisher.new(calendar).publish
    end

    I18n.locale = :cy
    CalendarPublisher.new(Calendar.find("bank-holidays"), slug: "gwyliau-banc").publish
  end

  desc "Unpublish help.json"
  task unpublish_help_json: :environment do
    api_client = GdsApi::PublishingApi.new(Plek.find("publishing-api"), bearer_token: ENV["PUBLISHING_API_BEARER_TOKEN"])
    api_client.unpublish("50aa0d27-ea4a-49b7-a1e6-98abd1115f60", type: "redirect", alternative_path: "/help", discard_drafts: true)
  end
end
