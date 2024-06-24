RSpec.describe "Help" do
  include GovukAbTesting::RspecHelpers
  include Capybara::RSpecMatchers

  before do
    GovukAbTesting.configure do |config|
      config.acceptance_test_framework = :active_support
    end
  end

  context "GET index" do
    before do
      content_store_has_random_item(base_path: "/help", schema: "help_page")
    end

    it "sets the cache expiry headers" do
      get "/help"

      honours_content_store_ttl
    end
  end

  context "loading the cookies setting page" do
    before do
      content_store_has_random_item(base_path: "/help/cookies", schema: "help_page")
    end

    it "responds with success" do
      get "/help/cookies"

      expect(response).to have_http_status(:ok)
    end

    it "sets the cache expiry headers" do
      get "/help/cookies"

      honours_content_store_ttl
    end
  end

  context "GET ab-testing" do
    %w[A B].each do |variant|
      it "does not affect non-AB-testing pages with the #{variant} variant" do
        content_store_has_random_item(base_path: "/help", schema: "help_page")
        # TODO: We have to add a bit of scaffolding here to handle the way that
        #       govuk_ab_testing expects us to have an @request object it can
        #       dump headers into. It looks like this is not how request specs
        #       ideally handle headers (they should be passed in in the actual
        #       get or post)
        request_headers = stub_at_request
        setup_ab_variant("Example", variant)
        get "/help", headers: request_headers

        assert_response_not_modified_for_ab_test("EducationNavigation")
      end
    end

    it "respond swith success" do
      content_store_has_random_item(base_path: "/help/ab-testing", schema: "help_page")
      get "/help/ab-testing"

      expect(response).to have_http_status(:ok)
    end

    it "shows the user the 'A' version if the user is in bucket 'A'" do
      request_headers = stub_at_request
      with_variant(Example: "A") do
        content_store_has_random_item(base_path: "/help/ab-testing", schema: "help_page")
        get "/help/ab-testing", headers: request_headers

        expect(response.body).to have_selector(".ab-example-group", text: "A")
      end
    end

    it "shows the user the 'B' version if the user is in bucket 'B'" do
      request_headers = stub_at_request
      with_variant(Example: "B") do
        content_store_has_random_item(base_path: "/help/ab-testing", schema: "help_page")
        get "/help/ab-testing", headers: request_headers

        expect(response.body).to have_selector(".ab-example-group", text: "B")
      end
    end

    it "shows the user the default version if the user is not in a bucket" do
      content_store_has_random_item(base_path: "/help/ab-testing", schema: "help_page")
      get "/help/ab-testing"

      expect(response.body).to have_selector(".ab-example-group", text: "A")
    end

    it "shows the user the default version if the user is in an unknown bucket" do
      content_store_has_random_item(base_path: "/help/ab-testing", schema: "help_page")
      request_headers = stub_at_request
      setup_ab_variant("Example", "not_a_valid_AB_test_value")
      get "/help/ab-testing", headers: request_headers

      expect(response.body).to have_selector(".ab-example-group", text: "A")
    end
  end

  def stub_at_request
    request_headers = {}
    @request = double
    allow(@request).to receive(:headers).and_return(request_headers)
    request_headers
  end
end
