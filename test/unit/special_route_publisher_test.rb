require "test_helper"

class SpecialRoutePublisherTest < ActiveSupport::TestCase
  setup do
    @publishing_api = Object.new

    logger = Logger.new($stdout)
    logger.level = Logger::WARN

    @publisher = SpecialRoutePublisher.new(
      publishing_api: @publishing_api,
      logger:,
    )
  end

  SpecialRoutePublisher.routes.each do |route_type, routes_for_type|
    routes_for_type.each do |route|
      should "should publish valid content item for #{route_type} route '#{route[:base_path]}'" do
        @publishing_api.expects(:put_content).with do |_, payload|
          assert_valid_content_item(payload)
        end
        @publishing_api.expects(:publish)

        if route[:links]
          @publishing_api.expects(:patch_links)
        end

        @publisher.publish(route_type, route)
      end
    end
  end

  def assert_valid_content_item(payload)
    validator = GovukSchemas::Validator.new(
      "special_route",
      "publisher",
      payload,
    )

    assert validator.valid?, validator.error_message
  end
end
