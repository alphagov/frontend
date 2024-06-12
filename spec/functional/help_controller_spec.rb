RSpec.describe HelpController, type: :controller do
  include GovukAbTesting::RspecHelpers

  render_views

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
      get(:index)

      honours_content_store_ttl
    end
  end

  context "loading the cookies setting page" do
    before do
      content_store_has_random_item(base_path: "/help/cookies", schema: "help_page")
    end

    it "responds with success" do
      get(:cookie_settings)

      assert_response(:success)
    end

    it "sets the cache expiry headers" do
      get(:cookie_settings)

      honours_content_store_ttl
    end
  end

  context "GET ab-testing" do
    %w[A B].each do |variant|
      it "does not affect non-AB-testing pages with the #{variant} variant" do
        content_store_has_random_item(base_path: "/help", schema: "help_page")
        setup_ab_variant("Example", variant)
        get(:index)

        assert_response_not_modified_for_ab_test("EducationNavigation")
      end
    end

    it "respond swith success" do
      content_store_has_random_item(base_path: "/help/ab-testing", schema: "help_page")
      get(:ab_testing, params: { slug: "help/ab-testing" })

      assert_response(:success)
    end

    it "shows the user the 'A' version if the user is in bucket 'A'" do
      with_variant(Example: "A") do
        content_store_has_random_item(base_path: "/help/ab-testing", schema: "help_page")
        get(:ab_testing)

        assert_select(".ab-example-group", text: "A")
      end
    end

    it "shows the user the 'B' version if the user is in bucket 'B'" do
      with_variant(Example: "B") do
        content_store_has_random_item(base_path: "/help/ab-testing", schema: "help_page")
        get(:ab_testing)

        assert_select(".ab-example-group", text: "B")
      end
    end

    it "shows the user the default version if the user is not in a bucket" do
      content_store_has_random_item(base_path: "/help/ab-testing", schema: "help_page")
      get(:ab_testing)

      assert_select(".ab-example-group", text: "A")
    end

    it "shows the user the default version if the user is in an unknown bucket" do
      content_store_has_random_item(base_path: "/help/ab-testing", schema: "help_page")
      setup_ab_variant("Example", "not_a_valid_AB_test_value")
      get(:ab_testing)

      assert_select(".ab-example-group", text: "A")
    end
  end
end
