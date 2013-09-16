require_relative "../test_helper"

class CampaignControllerTest < ActionController::TestCase

  should "set slimmer format of campaign" do
    get :workplace_pensions
    assert_equal "campaign",  response.headers["X-Slimmer-Format"]
  end

  should "set correct expiry headers" do
    get :workplace_pensions
    assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
  end

  should "load the workplace pensions campaign" do
    get :workplace_pensions
    assert_response :success
  end

  should "load the UK Welcomes campaign" do
    get :uk_welcomes
    assert_response :success
  end

  should "load the sort my tax campaign" do
    get :sort_my_tax
    assert_response :success
  end

  should "load the dvla new licence rules campaign" do
    get :new_licence_rules
    assert_response :success
  end

  should "load the firekills campaign" do
    get :fire_kills
    assert_response :success
  end

  should "load the know before you go campaign" do
    get :know_before_you_go
    assert_response :success
  end

  should "load the business support campaign" do
    get :business_support
    assert_response :success
  end

  context "the royal_mail_shares campaign" do

    context "before the start date" do
      setup do
        Timecop.freeze(CampaignController::ROYAL_MAIL_SHARES_START - 40.minutes)
      end

      should "return a 404" do
        get :royal_mail_shares
        assert_response :missing
      end

      should "not set the cache headers" do
        get :royal_mail_shares
        assert_nil response.headers["Cache-Control"]
      end

      should "show the page when given 'show_me_the_page' query param" do
        get :royal_mail_shares, :show_me_the_page => "1"
        assert_response :success
      end
    end

    context "after the start time" do
      setup do
        Timecop.freeze(CampaignController::ROYAL_MAIL_SHARES_START + 5.minutes)
      end

      should "show the page" do
        get :royal_mail_shares
        assert_response :success
      end

      should "set the cache headers" do
        get :royal_mail_shares
        assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
      end
    end
  end
end
