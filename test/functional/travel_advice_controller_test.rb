require 'test_helper'
require "gds_api/test_helpers/content_store"

class TravelAdviceControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore

  context "GET index" do
    context "given countries exist" do
      setup do
        json = GovukContentSchemaTestHelpers::Examples.new.get('travel_advice_index', 'index')
        @content_item = JSON.parse(json)
        base_path = @content_item.fetch("base_path")

        content_store_has_item(base_path, @content_item)
      end

      should "be a successful request" do
        get :index

        assert response.success?
      end

      should "send the artefact to slimmer" do
        get :index

        slimmer_header = @response.headers["X-Slimmer-Artefact"]
        content_item = JSON.parse(slimmer_header)

        assert_equal @content_item, content_item.except("tags")
      end

      should "set slimmer format to travel-advice" do
        get :index

        assert_equal 'travel-advice', @response.headers["X-Slimmer-Format"]
      end

      should "render the index template" do
        get :index

        assert_template "index"
      end

      should "set cache-control headers to 30 mins" do
        get :index

        assert_equal "max-age=#{30.minutes.to_i}, public", response.headers["Cache-Control"]
      end

      context "requesting json" do
        setup do
          get :index, format: 'json'
        end

        should "redirect json requests to the api" do
          assert_redirected_to "/api/foreign-travel-advice.json"
        end

        should "set cache-control headers to 30 mins" do
          assert_equal "max-age=#{30.minutes.to_i}, public", response.headers["Cache-Control"]
        end
      end

      context "requesting atom" do
        setup do
          get :index, format: 'atom'
        end

        should "return an aggregate of country atom feeds" do
          assert_equal 200, response.status
          assert_equal "application/atom+xml; charset=utf-8", response.headers["Content-Type"]
        end

        should "set cache-control headers to 5 mins" do
          assert_equal "max-age=#{5.minutes.to_i}, public", response.headers["Cache-Control"]
        end
      end
    end
  end
end
