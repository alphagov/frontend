RSpec.describe "Field of operation page" do
  describe "GET /<document_type>/<slug>" do
    let(:content_store_response) { GovukSchemas::Example.find("field_of_operation", example_name: "field_of_operation") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    context "when there are fatality notices present" do
      it "displays the page" do
        expect(page.status_code).to eq(200)
      end

      it "has the correct title" do
        expect(page.title).to eq("Iraq - GOV.UK")
      end

      it "has the correct heading, context, and locale" do
        within("h1") do
          expect(page).to have_text("Operations in Iraq")
        end
        within(".gem-c-heading__context") do
          expect(page).to have_text("British fatalities")
        end

        locale = page.find("main div:first-of-type > .gem-c-heading")["lang"]
        expect(locale).to eq content_store_response["locale"]
      end

      it "has the correct subheadings and description" do
        within("#field-of-operation > div:first-of-type h2") do
          expect(page).to have_text("Field of operation")
        end

        within("#field-of-operation") do
          expect(page).to have_text("It is with very deep regret that the following fatalities are announced.")
        end

        within("#fatalities h2") do
          expect(page).to have_text("Fatalities")
        end
      end

      it "doesn't render a subheading / description if the description is blank" do
        content_store_response["description"] = ""
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
        expect(page).not_to have_css("#field-of-operation > div:first-of-type h2", text: "Field of operation")
        expect(page).not_to have_css("#field-of-operation div[data-module=govspeak]")
      end

      it "doesn't render the description if it's an empty HTML element" do
        content_store_response["description"] = "<div class='govspeak' data-module='govspeak'></div>"
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
        expect(page).not_to have_css("#field-of-operation > div:first-of-type h2", text: "Field of operation")
        expect(page).not_to have_css("#field-of-operation div[data-module=govspeak]")
      end

      it "has the correct page text" do
        within("#field-of-operation div > ul.govuk-list") do
          expect(page).to have_text("A fatality sadly occurred on 1 December")
          expect(page).to have_text("A fatality sadly occurred on 2 December")
        end
      end

      it "has the correct links" do
        within("#field-of-operation div > ul.govuk-list") do
          expect(page).to have_link("A fatality notice", href: "/government/fatalities/fatality-notice-one")
          expect(page).to have_link("A second fatality notice", href: "/government/fatalities/fatality-notice-two")
        end
      end
    end

    context "when there are no fatality notices present" do
      it "doesn't render the fatality notice heading / list" do
        content_store_response["links"]["fatality_notices"] = []
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
        expect(page).not_to have_css("#fatalities")
        expect(page).not_to have_css("#fatalities ~ ul.govuk-list")
        expect(page).not_to have_css("li.fatality-notice")
      end
    end
  end
end
