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

  context "GET country" do
    context "given a valid country" do
      setup do
        @artefact = JSON.parse(File.read(Rails.root.join('test/fixtures/foreign-travel-advice/turks-and-caicos-islands.json')))
        content_api_has_an_artefact "foreign-travel-advice/turks-and-caicos-islands", @artefact
      end

      should "be a successful request" do
        get :country, country_slug: "turks-and-caicos-islands"

        assert response.success?
      end

      should "make a request to the content api with a concatenated slug" do
        stub_artefact = artefact_for_slug('foreign-travel-advice/turks-and-caicos-islands')
        stub_artefact['details']['country'] = {
          "name" => "Turks and Caicos Islands",
          "slug" => "turks-and-caicos-islands"
        }

        GdsApi::ContentApi.any_instance.expects(:artefact!).
          with('foreign-travel-advice/turks-and-caicos-islands', { }).returns(stub_artefact)

        @controller.stubs(:render)
        get :country, country_slug: "turks-and-caicos-islands"
      end

      should "assign the publication to the template" do
        get :country, country_slug: "turks-and-caicos-islands"

        assert_not_nil assigns(:publication)
        assert assigns(:publication).is_a?(TravelAdviceCountryPresenter)
        assert_equal "Turks and Caicos Islands extra special travel advice", assigns(:publication).title
      end

      should "render the country template" do
        get :country, country_slug: "turks-and-caicos-islands"

        assert_template "country"
      end

      should "set the locale to en" do
        I18n.expects(:locale=).with(:en)

        get :country, country_slug: "turks-and-caicos-islands"
      end

      should "set expiry headers to 5 mins" do
        get :country, country_slug: "turks-and-caicos-islands"

        assert_equal "max-age=300, public", response.headers["Cache-Control"]
      end

      should "assign the edition number when previewing a country" do
        get :country, country_slug: "turks-and-caicos-islands", edition: "5"

        assert_equal "5", assigns(:edition)
      end

      context "setting up slimmer artefact details" do
        should "expose artefact details in header" do
          @controller.stubs(:render)

          get :country, country_slug: "turks-and-caicos-islands"

          assert_equal "travel-advice", @response.headers["X-Slimmer-Format"]
        end

        should "set the artefact in the header with a section added" do
          @controller.stubs(:render)

          get :country, country_slug: "turks-and-caicos-islands"

          header_artefact = JSON.parse(@response.headers["X-Slimmer-Artefact"])
          assert_equal @artefact["title"], header_artefact["title"]
          assert_equal @artefact["details"], header_artefact["details"]

          section = header_artefact["tags"].first
          assert_equal "Foreign travel advice", section["title"]
          assert_equal "/foreign-travel-advice", section["content_with_tag"]["web_url"]
        end

        should "pass-through the primary section from the api" do
          @controller.stubs(:render)

          get :country, country_slug: "turks-and-caicos-islands"

          header_artefact = JSON.parse(@response.headers["X-Slimmer-Artefact"])

          parent = header_artefact["tags"].first["parent"]
          assert_equal "Travel abroad", parent["title"]
          assert_equal "https://www.gov.uk/browse/abroad/travel-abroad", parent["content_with_tag"]["web_url"]
        end
      end

      should "return a print variant" do
        @controller.stubs(:render)

        get :country, country_slug: "turks-and-caicos-islands", edition: "5", variant: :print

        assert_equal [:print], @request.variant
        assert_equal "print", @response.headers["X-Slimmer-Template"]
      end

      context "requesting the root 'part'" do
        should "not assign a part" do
          get :country, country_slug: "turks-and-caicos-islands"

          assert_nil assigns(:part)
        end
      end # root part

      context "requesting a part" do
        should "select a given part if it exists" do
          get :country, country_slug: "turks-and-caicos-islands", part: "page-two"

          assigned_part = assigns(:publication).current_part
          assert_equal "page-two", assigned_part.slug
          assert assigned_part.is_a?(PartPresenter)
          assert response.success?
        end

        should "redirect to the travel advice edition root when a part doesn't exist" do
          get :country, country_slug: "turks-and-caicos-islands", part: "nightlife"

          assert_redirected_to "/foreign-travel-advice/turks-and-caicos-islands"
        end
      end

      context "request as atom feed" do
        should "return the atom template" do
          get :country, format: 'atom', country_slug: "turks-and-caicos-islands"

          assert_equal 200, response.status
          assert_equal "application/atom+xml; charset=utf-8", response.headers["Content-Type"]
          assert_template "country"
        end
      end
    end

    should "return a 404 status for a country which doesn't exist" do
      content_api_does_not_have_an_artefact "foreign-travel-advice/timbuktu"

      get :country, country_slug: "timbuktu"

      assert response.not_found?
    end

    should "return a cacheable 404 without querying content_api for an invalid country slug" do
      get :country, country_slug: "this is not & a valid slug"
      assert response.not_found?
      assert_equal "max-age=600, public", response.headers["Cache-Control"]
      assert_not_requested(:get, %r{\A#{CONTENT_API_ENDPOINT}})
    end
  end
end
