require "integration_test_helper"

class ElectoralLookUpTest < ActionDispatch::IntegrationTest
  should "contain a form for entering a postcode" do
    visit "/find-electoral-things"
    assert page.has_selector?("h1", text: "Elections lookup", visible: true)
    assert page.has_field?("postcode")
  end

  should "search by entered postcode" do
    visit "/find-electoral-things"
    fill_in "postcode", with: "LS11UR"
    click_button "Find"

    assert page.has_text?("Cardiff Council")
  end
end
