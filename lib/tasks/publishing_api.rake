namespace :publishing_api do
  desc "Publish special routes such as the homepage"
  task publish_special_routes: :environment do
    logger = Logger.new(STDOUT)

    publisher = SpecialRoutePublisher.new(
      logger: logger,
      publishing_api: Services.publishing_api,
    )

    SpecialRoutePublisher.routes.each do |route_type, routes_for_type|
      routes_for_type.each do |route|
        publisher.publish(route_type, route)
      end
    end

    HomepagePublisher.publish!(Services.publishing_api, logger)
  end

  desc "Publish calendars"
  task publish_calendars: :environment do
    %w[bank-holidays when-do-the-clocks-change].each do |calender_name|
      calendar = Calendar.find(calender_name)
      CalendarPublisher.new(calendar).publish
    end
  end
end
