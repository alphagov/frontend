require "integration_test_helper"
class ElectoralLookUpTest < ActionDispatch::IntegrationTest
  setup do
    content = GovukSchemas::Example.find("local_transaction", example_name: "local_transaction")
    content["title"] = "Contact your local Electoral Registration Office"
    stub_content_store_has_item("/contact-electoral-registration-office", content)
  end

  should "contain a form for entering a postcode" do
    visit "/find-electoral-things"
    assert page.has_selector?("h1", text: "Contact your local Electoral Registration Office", visible: true)
    assert page.has_field?("postcode")
  end
end
