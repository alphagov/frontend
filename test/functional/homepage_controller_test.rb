require "test_helper"

class HomepageControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  context "loading the homepage" do
    setup do
      stub_content_store_has_item("/", schema: "special_route", links: {})
    end

    should "respond with success" do
      get :index
      assert_response :success
    end

    should "set correct expiry headers" do
      get :index
      honours_content_store_ttl
    end

    context "with popular links in the content item" do
      setup do
        links = {
          "popular_links" => [
            {
              "details" => {
                "link_items" => [
                  {
                    "title" => "Some popular links title",
                    "url" => "/some/path",
                  },
                ],
              },
            },
          ],
        }
        stub_content_store_has_item("/", schema: "special_route", links:)
      end

      should "show popular links" do
        get :index
        assert_match "Some popular links title", @response.body
      end
    end

    context "with popular links not in the content item" do
      should "show popular links" do
        get :index
        I18n.t("homepage.index.popular_links").each do |item|
          assert_match item[:title], @response.body
        end
      end
    end
  end
end
