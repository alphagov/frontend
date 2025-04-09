RSpec.describe "Fields of operation page" do
  describe "GET /<document_type>/<slug>" do
    let(:content_store_response) { GovukSchemas::Example.find("fields_of_operation", example_name: "fields_of_operation") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the page" do
      expect(page.status_code).to eq(200)
    end

    it "has the correct title" do
      expect(page.title).to eq("Fields of operation - GOV.UK")
    end

    it "has the correct heading, context, and locale" do
      within("h1") do
        expect(page).to have_text("Fields of operation")
      end
      within(".gem-c-heading__context") do
        expect(page).to have_text("British fatalities")
      end

      locale = page.find(".gem-c-heading")["lang"]
      expect(locale).to eq content_store_response["locale"]
    end

    it "has the correct links" do
      within(".govuk-list") do
        expect(page).to have_link("A field of operation", href: "/government/fields-of-operation/field-of-operation-one")
        expect(page).to have_link("Another field of operation", href: "/government/fields-of-operation/field-of-operation-two")
      end
    end
  end
end
