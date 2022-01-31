require "test_helper"
require "gds_api/test_helpers/content_store"

class TravelAdviceControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore

  context "GET index" do
    context "given countries exist" do
      setup do
        json = GovukContentSchemaTestHelpers::Examples.new.get("travel_advice_index", "index")
        @content_item = JSON.parse(json)
        base_path = @content_item.fetch("base_path")

        stub_content_store_has_item(base_path, @content_item)
      end

      should "be a successful request" do
        get :index

        assert response.successful?
      end

      should "render the index template" do
        get :index

        assert_template "index"
      end

      should "set cache-control headers" do
        get :index

        honours_content_store_ttl
      end

      context "requesting atom" do
        setup do
          get :index, format: "atom"
        end

        should "return an aggregate of country atom feeds" do
          assert_equal 200, response.status
          assert_equal "application/atom+xml; charset=utf-8", response.headers["Content-Type"]
        end

        should "set cache-control headers to 5 mins" do
          assert_equal "max-age=#{5.minutes.to_i}, public", response.headers["Cache-Control"]
        end

        should "set Access-Control-Allow-Origin header" do
          assert_equal "*", response.headers["Access-Control-Allow-Origin"]
        end
      end
    end
  end
end
