require_relative '../test_helper'

class TravelAdviceControllerTest < ActionController::TestCase

  context "GET index" do
    context "given countries exist" do
      setup do
        @json_data = File.read(Rails.root.join('test/fixtures/foreign-travel-advice/index2.json'))
        @index_artefact = GdsApi::ContentApi::Response.new(
          stub("HTTP_Response", :code => 200, :body => @json_data),
          :web_urls_relative_to => "https://www.gov.uk"
        )
        GdsApi::ContentApi.any_instance.stubs(:artefact).with('foreign-travel-advice').returns(@index_artefact)
      end

      should "be a successful request" do
        get :index

        assert response.success?
      end

      should "make a request to the content api for the travel advice top-level artefact" do
        GdsApi::ContentApi.any_instance.expects(:artefact).with('foreign-travel-advice').returns(@index_artefact)

        get :index
        assert_equal @index_artefact, assigns(:artefact)
      end

      should "send the artefact to slimmer" do
        get :index

        assert_equal JSON.dump(@index_artefact.to_hash), @response.headers["X-Slimmer-Artefact"]
      end

      should "set other slimmer headers" do
        get :index

        assert_equal 'custom-application', @response.headers["X-Slimmer-Format"]
        assert_equal '1', @response.headers["X-Slimmer-Beta"]
      end

      should "render the index template" do
        get :index

        assert_template "index"
      end

      should "set expiry headers to 5 mins" do
        get :index

        assert_equal "max-age=300, public",  response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :index, format: 'json'

        assert_redirected_to "/api/foreign-travel-advice.json"
      end

      context "requesting atom" do
        setup do
          get :index, :format => 'atom'
        end

        should "return an aggregate of country atom feeds" do
          assert_equal 200, response.status
          assert_equal "application/atom+xml; charset=utf-8", response.headers["Content-Type"]
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
        get :country, :country_slug => "turks-and-caicos-islands"

        assert response.success?
      end

      should "make a request to the content api with a concatenated slug" do
        stub_artefact = artefact_for_slug('foreign-travel-advice/turks-and-caicos-islands')
        stub_artefact['details']['country'] = {
          "name" => "Turks and Caicos Islands",
          "slug" => "turks-and-caicos-islands"
        }

        GdsApi::ContentApi.any_instance.expects(:artefact).
          with('foreign-travel-advice/turks-and-caicos-islands', { }).returns(stub_artefact)

        @controller.stubs(:render)
        get :country, :country_slug => "turks-and-caicos-islands"
      end

      should "assign the publication to the template" do
        get :country, :country_slug => "turks-and-caicos-islands"

        assert_not_nil assigns(:publication)
        assert assigns(:publication).is_a?(TravelAdviceCountryPresenter)
        assert_equal "Turks and Caicos Islands extra special travel advice", assigns(:publication).title
      end

      should "render the country template" do
        get :country, :country_slug => "turks-and-caicos-islands"

        assert_template "country"
      end

      should "set the locale to en" do
        I18n.expects(:locale=).with(:en)

        get :country, :country_slug => "turks-and-caicos-islands"
      end

      should "set expiry headers to 5 mins" do
        get :country, :country_slug => "turks-and-caicos-islands"

        assert_equal "max-age=300, public",  response.headers["Cache-Control"]
      end

      should "assign the edition number when previewing a country" do
        get :country, :country_slug => "turks-and-caicos-islands", :edition => "5"

        assert_equal "5", assigns(:edition)
      end

      context "setting up slimmer artefact details" do
        should "expose artefact details in header" do
          @controller.stubs(:render)

          get :country, :country_slug => "turks-and-caicos-islands"

          assert_equal "travel-advice", @response.headers["X-Slimmer-Format"]
          assert_equal '1', @response.headers["X-Slimmer-Beta"]
        end

        should "set the artefact in the header" do
          @controller.stubs(:render)

          get :country, :country_slug => "turks-and-caicos-islands"

          assert_equal JSON.dump(@artefact), @response.headers["X-Slimmer-Artefact"]
        end
      end

      should "return a print format" do
        @controller.stubs(:render)

        get :country, :country_slug => "turks-and-caicos-islands", :edition => "5", :format => "print"

        assert_equal "print", @request.format
        assert_equal "print", @response.headers["X-Slimmer-Template"]
      end

      context "requesting the root 'part'" do
        should "not assign a part" do
          get :country, :country_slug => "turks-and-caicos-islands"

          assert_nil assigns(:part)
        end
      end # root part

      context "requesting a part" do
        should "select a given part if it exists" do
          get :country, :country_slug => "turks-and-caicos-islands", :part => "page-two"

          assert_equal "page-two", assigns(:part).slug
          assert assigns(:part).is_a?(PartPresenter)
          assert response.success?
        end

        should "redirect to the travel advice edition root when a part doesn't exist" do
          get :country, :country_slug => "turks-and-caicos-islands", :part => "nightlife"

          assert_redirected_to "/foreign-travel-advice/turks-and-caicos-islands"
        end
      end

      context "request as atom feed" do
        should "return the atom template" do
          get :country, :format => 'atom', :country_slug => "turks-and-caicos-islands"

          assert_equal 200, response.status
          assert_equal "application/atom+xml; charset=utf-8", response.headers["Content-Type"]
          assert_template "country"
        end
      end
    end

    should "return a 404 status for a country which doesn't exist" do
      content_api_does_not_have_an_artefact "foreign-travel-advice/timbuktu"

      get :country, :country_slug => "timbuktu"

      assert response.not_found?
    end
  end
end
