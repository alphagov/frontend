require "test_helper"

class ElectoralControllerTest < ActionController::TestCase
  setup do
    stub_content_store_has_item("/contact-electoral-registration-office")
  end

  test "GET show" do
    get :show
    assert_response :success
    assert_template "local_transaction/search"
    assert_template partial: "electoral/_form"
    assert_template partial: "application/_location_form", count: 0
  end
end
