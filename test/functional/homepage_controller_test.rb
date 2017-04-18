require 'test_helper'

class HomepageControllerTest < ActionController::TestCase
  context "loading the homepage" do
    setup do
      content_store_has_item("/", schema: 'special_route')
    end

    should "respond with success" do
      get :index
      assert_response :success
    end

    should "set correct expiry headers" do
      get :index
      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end

    context "with a blank promo banner partial" do
      should "not render the promo banner" do
        stub_template "homepage/_promo_banner.html.erb" => "<%# foo %>"

        get :index
        assert_template "homepage/_promo_banner"
        refute @response.body.include?("homepage-promo-banner")
      end
    end

    context "with a promo banner partial" do
      setup do
        stub_template "homepage/_promo_banner.html.erb" => <<-EOF
        <div id="homepage-promo-banner">
          <div class="banner-message">
            <p><strong>Some Title</strong> On some date something has happened.
            <a href="https://something.gov.uk" rel="external nofollow">More&nbsp;information</a></p>
          </div>
        </div>
        EOF
      end

      context "with an emergency banner enabled" do
        should "not render the promo banner" do
          EmergencyBanner.any_instance.stubs(:enabled?).returns(true)
          get :index
          refute @response.body.include?("homepage-promo-banner")
        end
      end

      context "with an emergency banner not enabled" do
        should "render promo banner" do
          EmergencyBanner.any_instance.stubs(:enabled?).returns(false)
          get :index
          assert_template "homepage/_promo_banner"
          assert @response.body.include?("homepage-promo-banner")
          assert @response.body.include?("Some Title")
        end
      end
    end
  end

  def stub_template(hash)
    require 'action_view/testing/resolvers'
    @controller.view_paths.unshift(ActionView::FixtureResolver.new(hash))
  end
end
