require 'gds_api/publishing_api_v2'

namespace :publishing_api do
  desc "Publish special routes such as the homepage"
  task publish_special_routes: :environment do
    publishing_api = GdsApi::PublishingApiV2.new(
      Plek.new.find('publishing-api'),
      bearer_token: ENV['PUBLISHING_API_BEARER_TOKEN'] || 'example')

    logger = Logger.new(STDOUT)

    publisher = SpecialRoutePublisher.new(
      logger: logger,
      publishing_api: publishing_api)

    SpecialRoutePublisher.routes.each do |route_type, routes_for_type|
      routes_for_type.each do |route|
        publisher.publish(route_type, route)
      end
    end

    HomepagePublisher.publish!(publishing_api, logger)
  end
end
