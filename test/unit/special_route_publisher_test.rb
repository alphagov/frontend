require 'test_helper'

class SpecialRoutePublisherTest < ActiveSupport::TestCase
  setup do
    GovukContentSchemaTestHelpers.configure do |config|
      config.schema_type = 'publisher_v2'
      config.project_root = Rails.root
    end

    @publishing_api = Object.new

    logger = Logger.new(STDOUT)
    logger.level = Logger::WARN

    @publisher = SpecialRoutePublisher.new(
      publishing_api: @publishing_api,
      logger: logger
    )
  end

  SpecialRoutePublisher.routes.each do |route_type, routes_for_type|
    routes_for_type.each do |route|
      should "should publish valid content item for #{route_type} route '#{route[:base_path]}'" do
        @publishing_api.expects(:put_content).with { |_, payload|
          assert_valid_content_item(payload)
        }
        @publishing_api.expects(:publish)

        if route[:links]
          @publishing_api.expects(:patch_links)
        end

        @publisher.publish(route_type, route)
      end
    end
  end

  def assert_valid_content_item(payload)
    validator = GovukContentSchemaTestHelpers::Validator.new(
      "special_route",
      "schema",
      payload
    )

    assert validator.valid?, validator.errors.join("\n")
  end
end
