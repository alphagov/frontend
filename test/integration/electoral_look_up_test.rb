require "integration_test_helper"

class ElectoralLookUpTest < ActionDispatch::IntegrationTest
  include ElectionHelpers

  setup do
    content = GovukSchemas::Example.find("local_transaction", example_name: "local_transaction")
    content["title"] = "Contact your local Electoral Registration Office"
    stub_content_store_has_item("/contact-electoral-registration-office", content)
  end

  def search_for(postcode:)
    visit electoral_services_path
    fill_in "postcode", with: postcode
    click_button "Find"
  end

  context "visiting the homepage" do
    should "contain a form for entering a postcode" do
      visit electoral_services_path
      assert_title("Contact your local Electoral Registration Office - GOV.UK")
      assert page.has_selector?("h1", text: "Contact your local Electoral Registration Office")
      assert page.has_field?("postcode")
      assert_no_text("This isn't a valid")
    end
  end

  context "searching by postcode" do
    context "when a valid postcode is entered which matches a single address" do
      should "display the electoral service (council) address if it's different to the registration office address" do
        with_different_address = JSON.parse(api_response)
        with_different_address["registration"] = { "address" => "foo" }
        with_different_address["electoral_services"] = { "address" => "bar" }
        stub_api_postcode_lookup("LS11UR", response: with_different_address.to_json)

        with_electoral_api_url do
          search_for(postcode: "LS11UR")
          assert page.has_selector?("h2", text: "Your local council")
          assert page.has_text? "For questions about your poll card, polling place, or about returning your postal voting ballot, contact your council."
          assert page.has_selector?("address", text: "foo")

          assert page.has_selector?("h2", text: "Get help with electoral registration")
          assert page.has_text? "Need help? Get in touch with your local electoral registration team."
          assert page.has_selector?("address", text: "bar")
        end
      end

      should "not display the electoral service (council) address if it's the same as the registration office address" do
        duplicate_contact_information = JSON.parse(api_response)
        duplicate_contact_information["registration"] = { "address" => "foo" }
        duplicate_contact_information["electoral_services"] = { "address" => "foo" }
        stub_api_postcode_lookup("LS11UR", response: duplicate_contact_information.to_json)

        with_electoral_api_url do
          search_for(postcode: "LS11UR")

          assert page.has_no_selector?("h2", text: "Your local council")
          assert page.has_no_text?("For questions about your poll card, polling place, or about returning your postal voting ballot, contact your council.")
        end
      end

      should "with an invalid postcode" do
        with_electoral_api_url do
          search_for(postcode: "INVALID POSTCODE")
          assert_selector("h1", text: "Contact your local Electoral Registration Office")
          assert_text("This isn't a valid postcode")
        end
      end
    end

    context "when a valid postcode is entered which matches multiple ERO addresses" do
      should "display an address picker" do
        postcode = "IP224DN"
        with_multiple_addresses = JSON.parse(api_response)
        with_multiple_addresses["electoral_services"] = nil
        with_multiple_addresses["registration"] = nil
        with_multiple_addresses["address_picker"] = true
        with_multiple_addresses["addresses"] = [
          {
            "address" => "1 BUCKINGHAM PALACE",
            "postcode" => postcode,
            "slug" => "1234",
            "url" => "/foo",
          },
          {
            "address" => "2 BUCKINGHAM PALACE",
            "postcode" => postcode,
            "slug" => "5678",
            "url" => "/bar",
          },
        ]
        # Search for postcode
        stub_api_postcode_lookup(postcode, response: with_multiple_addresses.to_json)

        with_electoral_api_url do
          search_for(postcode:)

          # Multiple addresses are displayed
          assert page.has_selector?("h1", text: "Choose your address")
          assert page.has_selector?("p", text: "The IP22 4DN postcode could be in several council areas. Please choose your address from the list below.")
          assert page.has_select?("uprn", options: ["1 BUCKINGHAM PALACE", "2 BUCKINGHAM PALACE"])
          assert page.has_selector?("meta[name=robots][content=noindex]", visible: :all)

          # Click on one of the suggested addresses
          stub_api_address_lookup("1234", response: api_response)
          click_button "Continue"
          assert page.has_selector?("p", text: "We've matched the postcode to Cardiff Council")
        end
      end

      should "with an invalid uprn" do
        with_electoral_api_url do
          visit electoral_services_path(uprn: "INVALID UPRN")
          assert_selector("h1", text: "Contact your local Electoral Registration Office")
          assert_text("This isn't a valid address")
        end
      end
    end
  end

  context "API errors" do
    context "400 and 404" do
      should "display unfindable postcode message" do
        stub_api_postcode_lookup("XM45HQ", status: 404)

        with_electoral_api_url do
          search_for(postcode: "XM4 5HQ")

          assert_text("We couldn't find this postcode")
        end
      end

      should "display unfindable address message" do
        stub_api_address_lookup("1234", status: 400)

        with_electoral_api_url do
          visit electoral_services_path(uprn: "1234")

          assert_text("We couldn't find this address")
        end
      end
    end
  end
end
