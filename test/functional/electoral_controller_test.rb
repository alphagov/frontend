require "test_helper"

class ElectoralControllerTest < ActionController::TestCase
  setup do
    stub_content_store_has_item("/contact-electoral-registration-office")
  end

  context "without postcode params" do
    should "GET show renders show page with form" do
      get :show
      assert_response :success
      assert_template "local_transaction/search"
      assert_template partial: "electoral/_form"
      assert_template partial: "application/_location_form", count: 0
    end
  end

  context "with postcode params" do
    should "GET show renders results page" do
      get :show, params: { postcode: "LS11UR" }
      assert_response :success
      assert_template :results
    end
  end
end
