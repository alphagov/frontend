RSpec.describe "Service Toolkit page" do
  describe "GET /<document_type>/<slug>" do
    let(:content_store_response) { GovukSchemas::Example.find("service_manual_service_toolkit", example_name: "service_manual_service_toolkit") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the page" do
      expect(page.status_code).to eq(200)
    end

    it "has the correct title" do
      expect(page.title).to eq("Service Toolkit - GOV.UK")
    end

    it "has the correct heading and description" do
      within("h1") do
        expect(page).to have_text("Design and build government services")
      end

      within(".gem-c-lead-paragraph") do
        expect(page).to have_text("All you need to design, build and run services that meet government standards.")
      end
    end

    it "has two collections of links" do
      expect(content_store_response["details"]["collections"].size).to eq 2
    end

    it "has the correct level 2 headings" do
      within(".service-toolkit:nth-of-type(1) h2") do
        expect(page).to have_text "Standards"
      end

      within(".service-toolkit:nth-of-type(2) h2") do
        expect(page).to have_text "Buying"
      end
    end

    it "has the correct collection descriptions" do
      puts page.html

      within(".service-toolkit:nth-of-type(1) p.govuk-body-l") do
        expect(page).to have_text "Meet the standards for government services"
      end

      within(".service-toolkit:nth-of-type(2) p.govuk-body-l") do
        expect(page).to have_text "Extra skills, people and technology to help build your service"
      end
    end

    it "has the correct collection links" do
      within(".service-toolkit:nth-of-type(1)") do
        expect(page).to have_link("Service Standard", href: "https://www.gov.uk/service-manual/service-standard")
      end

      within(".service-toolkit:nth-of-type(2)") do
        expect(page).to have_link("Digital Marketplace", href: "https://www.gov.uk/digital-marketplace")
      end
    end

    it "has the correct collection link descriptions" do
      within(".service-toolkit:nth-of-type(1) div.govuk-grid-column-one-half:last-of-type p") do
        expect(page).to have_text "How to build a service that meets the standard: agile delivery, technology, user research, accessibility, training options and more"
      end

      within(".service-toolkit:nth-of-type(2) div.govuk-grid-column-one-half:last-of-type p") do
        expect(page).to have_text "Buy cloud technology and specialist services for digital projects"
      end
    end
  end
end
