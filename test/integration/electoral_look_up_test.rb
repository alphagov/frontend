require "integration_test_helper"

class ElectoralLookUpTest < ActionDispatch::IntegrationTest
  def search_for(postcode:)
    visit "/find-electoral-things"
    fill_in "postcode", with: postcode
    click_button "Find"
  end

  context "visiting the homepage" do
    should "contain a form for entering a postcode" do
      visit "/find-electoral-things"
      assert page.has_selector?("h1", text: "Elections lookup", visible: true)
      assert page.has_field?("postcode")
    end
  end

  context "searching by postcode" do
    context "when a valid postcode is entered which matches a single electoral service" do
      should "display contact details if available" do
        search_for(postcode: "LS11UR")

        assert page.has_selector?("h2", text: "Your local council")
        assert page.has_text? "For questions about your poll card, polling place, or about returning your postal voting ballot, contact your council."
        assert page.has_selector?("address", text: "Electoral Registration Office")
        assert page.has_selector?("h2", text: "Get help with electoral registration")
      end

      # TODO: should "display a helpful message if no contact details are present" do
      #   setup do
      #     stub_api_call
      #   end
      #
      #   assert page.has_selector?("h2", text: "Get help with electoral registration")
      #   assert page.has_text?("Need help? Get in touch with your local electoral registration team.")
      # end
    end
  end
end
