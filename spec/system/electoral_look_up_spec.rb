RSpec.describe "ElectoralLookUp", type: :system do
  include ElectionHelpers

  before do
    content = GovukSchemas::Example.find("local_transaction", example_name: "local_transaction")
    content["title"] = "Contact your local Electoral Registration Office"
    stub_content_store_has_item("/contact-electoral-registration-office", content)
  end

  def search_for(postcode:)
    visit(electoral_services_path)
    fill_in("postcode", with: postcode)
    click_button("Find")
  end

  context "visiting the homepage" do
    it "contains a form for entering a postcode" do
      visit(electoral_services_path)

      expect(page).to have_title("Contact your local Electoral Registration Office - GOV.UK")
      expect(page).to have_selector("h1", text: "Contact your local Electoral Registration Office")
      expect(page).to have_field("postcode")
      expect(page).not_to have_text("This isn't a valid")
    end
  end

  context "searching by postcode" do
    context "when a valid postcode is entered which matches a single address" do
      it "displays the electoral service (council) address if it's different to the registration office address" do
        with_different_address = JSON.parse(api_response)
        with_different_address["registration"] = { "address" => "foo" }
        with_different_address["electoral_services"] = { "address" => "bar" }
        stub_api_postcode_lookup("LS11UR", response: with_different_address.to_json)
        with_electoral_api_url do
          search_for(postcode: "LS11UR")

          expect(page).to have_selector("h2", text: "Your local council")
          expect(page).to have_text("For questions about your poll card, polling place, or about returning your postal voting ballot, contact your council.")
          expect(page).to have_selector("address", text: "foo")
          expect(page).to have_selector("h2", text: "Get help with electoral registration")
          expect(page).to have_text("Need help? Get in touch with your local electoral registration team.")
          expect(page).to have_selector("address", text: "bar")
        end
      end

      it "has GA4 tracking attributes on the HTML" do
        with_different_address = JSON.parse(api_response)
        with_different_address["registration"] = { "address" => "foo" }
        with_different_address["electoral_services"] = { "address" => "bar" }
        stub_api_postcode_lookup("LS11UR", response: with_different_address.to_json)
        with_electoral_api_url do
          search_for(postcode: "LS11UR")

          expect(page).to have_selector("p[data-module=ga4-auto-tracker]")
          expect(page).to have_selector("p[data-ga4-auto]")
          expect(page).to have_selector("div[data-module=ga4-link-tracker]")
          expect(page).to have_selector("div[data-ga4-track-links-only]")
          expect(page).to have_selector("div[data-ga4-set-indexes]")
          expect(page).to have_selector("div[data-ga4-link='{\"event_name\":\"information_click\",\"type\":\"local transaction\",\"tool_name\":\"Contact your local Electoral Registration Office\",\"action\":\"information click\"}']")
        end
      end

      it "does not display the electoral service (council) address if it's the same as the registration office address" do
        duplicate_contact_information = JSON.parse(api_response)
        duplicate_contact_information["registration"] = { "address" => "foo" }
        duplicate_contact_information["electoral_services"] = { "address" => "foo" }
        stub_api_postcode_lookup("LS11UR", response: duplicate_contact_information.to_json)
        with_electoral_api_url do
          search_for(postcode: "LS11UR")

          expect(page).not_to have_selector("h2", text: "Your local council")
          expect(page).not_to have_text("For questions about your poll card, polling place, or about returning your postal voting ballot, contact your council.")
        end
      end

      it "with an invalid postcode" do
        with_electoral_api_url do
          search_for(postcode: "INVALID POSTCODE")

          expect(page).to have_selector("h1", text: "Contact your local Electoral Registration Office")
          expect(page).to have_text("This isn't a valid postcode")
        end
      end
    end

    context "when a valid postcode is entered which matches multiple ERO addresses" do
      it "displays an address picker" do
        postcode = "IP224DN"
        with_multiple_addresses = JSON.parse(api_response)
        with_multiple_addresses["electoral_services"] = nil
        with_multiple_addresses["registration"] = nil
        with_multiple_addresses["address_picker"] = true
        with_multiple_addresses["addresses"] = [{ "address" => "1 BUCKINGHAM PALACE", "postcode" => postcode, "slug" => "1234", "url" => "/foo" }, { "address" => "2 BUCKINGHAM PALACE", "postcode" => postcode, "slug" => "5678", "url" => "/bar" }]
        stub_api_postcode_lookup(postcode, response: with_multiple_addresses.to_json)
        with_electoral_api_url do
          search_for(postcode:)

          expect(page).to have_selector("h1", text: "Choose your address")
          expect(page).to have_selector("p", text: "The IP22 4DN postcode could be in several council areas. Please choose your address from the list below.")
          expect(page).to have_select("uprn", options: ["1 BUCKINGHAM PALACE", "2 BUCKINGHAM PALACE"])
          expect(page).to have_selector("meta[name=robots][content=noindex]", visible: :all)

          stub_api_address_lookup("1234", response: api_response)
          click_button("Continue")

          expect(page).to have_selector("p", text: "We’ve matched the postcode to Cardiff Council")
        end
      end

      it "with an invalid uprn" do
        with_electoral_api_url do
          visit(electoral_services_path(uprn: "INVALID UPRN"))
          expect(page).to have_selector("h1", text: "Contact your local Electoral Registration Office")
          expect(page).to have_text("This isn't a valid address")
        end
      end
    end
  end

  context "API errors" do
    context "400 and 404" do
      it "displays unfindable postcode message" do
        stub_api_postcode_lookup("XM45HQ", status: 404)
        with_electoral_api_url do
          search_for(postcode: "XM4 5HQ")
          expect(page).to have_text("We couldn't find this postcode")
        end
      end

      it "displays unfindable address message" do
        stub_api_address_lookup("1234", status: 400)
        with_electoral_api_url do
          visit(electoral_services_path(uprn: "1234"))
          expect(page).to have_text("We couldn't find this address")
        end
      end
    end
  end
end
