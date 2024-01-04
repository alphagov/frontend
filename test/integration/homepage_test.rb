require "integration_test_helper"

class HomepageTest < ActionDispatch::IntegrationTest
  include GovukAbTesting::MinitestHelpers

  setup do
    stub_content_store_has_item("/", schema: "special_route")
  end

  should "render the homepage" do
    visit "/"
    assert_equal 200, page.status_code
    assert_equal "Welcome to GOV.UK", page.title
    assert page.has_css?(".homepage-header__title")
    assert page.has_no_css?(".homepage-inverse-header__title")
  end

  context "when visiting a Welsh content item first" do
    setup do
      @payload = {
        base_path: "/cymraeg",
        content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f",
        document_type: "transaction",
        locale: "cy",
        publishing_app: "publisher",
        rendering_app: "frontend",
        schema_name: "transaction",
        title: "Cymraeg",
        description: "Cynnwys Cymraeg",
        details: {
          transaction_start_link: "http://cymraeg.example.com",
          start_button_text: "Start now",
        },
      }
      stub_content_store_has_item("/cymraeg", @payload)
    end

    should "use the English locale after visiting the Welsh content" do
      visit @payload[:base_path]
      visit "/"
      assert page.has_content?(I18n.t("homepage.index.government_activity_description", locale: :en))
    end
  end

  context "when AB testing different popular links" do
    should "have different links for the B variant" do
      with_variant HomepagePopularLinksTest: "B" do
        visit "/"
        assert page.has_text?("Get information about a company")
      end
    end

    should "have different links for the A variant" do
      with_variant HomepagePopularLinksTest: "A" do
        visit "/"
        assert page.has_text?("Find out about help you can get with your energy bills")
      end
    end

    should "have different links for the Z variant" do
      with_variant HomepagePopularLinksTest: "Z" do
        visit "/"
        assert page.has_text?("Find out about help you can get with your energy bills")
      end
    end

    should "have different links for the C variant" do
      with_variant HomepagePopularLinksTest: "C" do
        visit "/"
        assert page.has_text?("Sign in to your childcare account")
      end
    end

    should "have different links for the D variant" do
      with_variant HomepagePopularLinksTest: "D" do
        visit "/"
        assert page.has_text?("Find an energy certificate")
      end
    end
  end
end
