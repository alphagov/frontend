require_relative '../test_helper'

class TravelAdviceControllerTest < ActionController::TestCase

  context "GET country" do
    context "given a valid country" do
      setup do
        artefact = {
          "title" => "Turks and Caicos Islands",
          "web_url" => "https://www.gov.uk/travel-advice/turks-and-caicos-islands",
          "format" => "travel-advice",
          "details" => {
            "parts" => [
              {
                "title" => "Summary",
                "body" => "<h1>Summary</h1>",
                "slug" => "summary"
              },
              {
                "title" => "Advice",
                "body" => "<h1>Advice</h1>",
                "slug" => "advice"
              }
            ],
            "country" => {
              "name" => "Turks and Caicos Islands",
              "slug" => "turks-and-caicos-islands"
            }
          }
        }
        content_api_has_an_artefact "travel-advice/turks-and-caicos-islands", artefact
      end

      should "be a successful request" do
        get :country, :slug => "turks-and-caicos-islands"

        assert response.success?
      end

      should "make a request to the content api with a concatenated slug" do
        stub_artefact = artefact_for_slug('travel-advice/turks-and-caicos-islands')
        stub_artefact['details']['country'] = {
          "name" => "Turks and Caicos Islands",
          "slug" => "turks-and-caicos-islands"
        }

        GdsApi::ContentApi.any_instance.expects(:artefact).
          with('travel-advice/turks-and-caicos-islands', { }).returns(stub_artefact)

        get :country, :slug => "turks-and-caicos-islands"
      end

      should "assign the publication to the template" do
        get :country, :slug => "turks-and-caicos-islands"

        assert_not_nil assigns(:publication)
        assert assigns(:publication).is_a?(PublicationPresenter)
        assert_equal "Turks and Caicos Islands", assigns(:publication).title
      end

      should "render the country template" do
        get :country, :slug => "turks-and-caicos-islands"

        assert_template "country"
      end

      should "select the first part by default" do
        get :country, :slug => "turks-and-caicos-islands"

        assert_equal "summary", assigns(:part).slug
      end

      should "select a given part if it exists" do
        get :country, :slug => "turks-and-caicos-islands", :part => "advice"

        assert_equal "advice", assigns(:part).slug
        assert response.success?
      end

      should "redirect to the travel advice edition root when a part doesn't exist" do
        get :country, :slug => "turks-and-caicos-islands", :part => "nightlife"

        assert_redirected_to "/travel-advice/turks-and-caicos-islands"
      end

      should "set correct expiry headers" do
        get :country, :slug => "turks-and-caicos-islands"

        assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
      end
    end

    should "return a 404 status for a country which doesn't exist" do
      content_api_does_not_have_an_artefact "travel-advice/timbuktu"

      get :country, :slug => "timbuktu"

      assert response.not_found?
    end
  end

end
