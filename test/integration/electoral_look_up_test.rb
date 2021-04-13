require "integration_test_helper"

class ElectoralLookUpTest < ActionDispatch::IntegrationTest
  def search_for(postcode:)
    visit "/find-electoral-things"
    fill_in "postcode", with: postcode
    click_button "Find"
  end

  def api_response
    path = Rails.root.join("test/fixtures/electoral-result.json")
    File.read(path)
  end

  def stub_democracy_club_api(response)
    stub_request(:get, "https://api.ec-dc.club/api/v1/postcode/LS11UR")
      .to_return(body: response)
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
      should "display contact details, and upcoming elections if available" do
        stub_democracy_club_api(api_response)

        search_for(postcode: "LS11UR")

        assert page.has_selector?("h2", text: "Your local council")
        assert page.has_text? "For questions about your poll card, polling place, or about returning your postal voting ballot, contact your council."
        assert page.has_selector?("address", text: "Electoral Registration Office")
        assert page.has_selector?("h2", text: "Get help with electoral registration")
        assert page.has_selector?("h2", text: "Next elections")
        assert page.has_text?("2017-05-04 - Cardiff local election Pontprennau/Old St. Mellons")
      end

      should "display a helpful message if no contact details are present" do
        without_contact_information = JSON.parse(api_response)
        without_contact_information["registration"] = {}
        stub_democracy_club_api(without_contact_information.to_json)
        search_for(postcode: "LS11UR")

        assert page.has_selector?("h2", text: "Get help with electoral registration")
        assert page.has_text?("Need help? Get in touch with your local electoral registration team.")
      end

      should "inform user if there are no upcoming elections " do
        without_dates = JSON.parse(api_response)
        without_dates["dates"] = []
        stub_democracy_club_api(without_dates.to_json)
        search_for(postcode: "LS11UR")

        assert page.has_selector?("h2", text: "Next elections")
        assert page.has_text?("There are no upcoming elections for your area")
      end
    end
  end
end
