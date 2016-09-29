require "test_helper"

class HelpControllerTest < ActionController::TestCase
  context "GET index" do
    setup do
      @json_data = File.read(Rails.root.join('test/fixtures/help.json'))
      @artefact = GdsApi::Response.new(
        stub("HTTP_Response", code: 200, body: @json_data),
        web_urls_relative_to: "https://www.gov.uk"
      )
      GdsApi::ContentApi.any_instance.stubs(:artefact!).returns(@artefact)
      #@controller.stubs(:fetch_artefact).returns(@index_artefact)
    end

    should "send the artefact to slimmer" do
      get :index

      assert_equal @artefact.to_hash.to_json, @response.headers["X-Slimmer-Artefact"]
    end

    should "set the slimmer format" do
      get :index

      assert_equal "help_page", response.headers["X-Slimmer-Format"]
    end

    should "set the cache expiry headers" do
      get :index

      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end

    should "redirect json requests to the api" do
      get :index, format: 'json'

      assert_redirected_to "/api/help.json"
    end
  end
end
