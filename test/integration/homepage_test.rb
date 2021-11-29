require "integration_test_helper"

class HomepageTest < ActionDispatch::IntegrationTest
  setup do
    stub_content_store_has_item("/", schema: "special_route")
  end

  should "render the homepage" do
    visit "/"
    assert_equal 200, page.status_code
    assert_equal "Welcome to GOV.UK", page.title
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
      assert page.has_content?(I18n.t("homepage.index.passport_fees", locale: :en))
      assert_not page.has_content?(I18n.t("homepage.index.passport_fees", locale: :cy))
    end
  end
end
