require "test_helper"

class CampaignControllerTest < ActionController::TestCase
  context "campaigns edited normally in Publisher" do
    context "GET show" do
      setup do
        @artefact = artefact_for_slug('firekills')
        @artefact["format"] = "campaign"
      end

      context "for live content" do
        setup do
          content_api_and_content_store_have_page('firekills', @artefact)
        end

        should "set the cache expiry headers" do
          get :show, slug: "firekills"

          assert_equal "max-age=1800, public", response.headers["Cache-Control"]
        end

        should "redirect json requests to the api" do
          get :show, slug: "firekills", format: 'json'

          assert_redirected_to "/api/firekills.json"
        end
      end

      context "for draft content" do
        setup do
          content_api_and_content_store_have_unpublished_page("firekills", 3, @artefact)
        end

        should "does not set the cache expiry headers" do
          get :show, slug: "firekills", edition: 3

          assert_nil response.headers["Cache-Control"]
        end
      end
    end
  end

  context "UK Welcomes campaign" do
    should "set correct expiry headers" do
      get :uk_welcomes
      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end

    should "load the UK Welcomes campaign" do
      get :uk_welcomes
      assert_response :success
    end
  end
end
