require "integration_test_helper"

class ElectoralLookUpTest < ActionDispatch::IntegrationTest
  should "contain a form for entering a postcode" do
    visit "/find-electoral-things"
    assert page.has_selector?("h1", text: "Elections lookup", visible: true)
    assert page.has_field?("postcode")
  end
end
