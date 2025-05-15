RSpec.describe CorporateInformationPagePresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page") }
  let(:content_item) { CorporateInformationPage.new(content_store_response) }

  describe "#headers_for_contents_list_component" do
    context "when there are headers in the details hash" do
      it "returns an array of H2 headers" do
        contents_list_headings = presenter.headers_for_contents_list_component

        expect(contents_list_headings).not_to be_empty
      end

      it "does not include nested h3s in the array" do
        content_store_response["details"]["headers"] = [
          { "text" => "Our responsibilities",
            "level" => 2,
            "id" => "our-responsibilities",
            "headers" => [
              { "text" => "Audit and risk committee meetings",
                "level" => 3,
                "id" => "audit-and-risk-committee-meetings" },
            ] },
          { "text" => "Who we are",
            "level" => 2,
            "id" => "who-we-are" },
          { "text" => "Agencies and public bodies",
            "level" => 2,
            "id" => "agencies-and-public-bodies" },
        ]

        contents_list_headings = presenter.headers_for_contents_list_component

        contents_list_headings.each do |heading|
          expect(heading[:items]).to be_empty
        end
      end

      context "when there are corporate information groups" do
        it "includes the corporate information H2 at the end of the headers array" do
          contents_list_headings = presenter.headers_for_contents_list_component
          corporate_information_heading = contents_list_headings.last

          expect(corporate_information_heading[:text]).to eq("Corporate information")
          expect(corporate_information_heading[:href]).to eq("#corporate-information")
          expect(contents_list_headings.count).to eq(5)
        end
      end

      context "when there are no corporate information groups available" do
        it "does not include the corporate information H2 at the end of the headers array" do
          content_store_response["details"].delete("corporate_information_groups")
          contents_list_headings = presenter.headers_for_contents_list_component
          corporate_information_heading = contents_list_headings.last

          expect(corporate_information_heading[:text]).not_to eq("Corporate information")
          expect(corporate_information_heading[:href]).not_to eq("#corporate-information")
          expect(contents_list_headings.count).to eq(4)
        end
      end
    end

    context "when there are no headers in the details hash" do
      let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "best-practice-welsh-language-scheme") }

      it "returns an empty array" do
        expect(presenter.headers_for_contents_list_component).to be_empty
      end

      context "when there are corporate information groups" do
        let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "best-practice-about-page") }

        it "adds the corporate information H2 to the empty array" do
          contents_list_headings = presenter.headers_for_contents_list_component
          corporate_information_heading = contents_list_headings.first
          expect(corporate_information_heading[:text]).to eq("Corporate information")
          expect(corporate_information_heading[:href]).to eq("#corporate-information")
          expect(contents_list_headings.count).to eq(1)
        end
      end
    end
  end

  describe "#further_information" do
    context "when there are corporate information pages" do
      it "presents further information based on corporate information page links" do
        expect(presenter.further_information).to include("Publication scheme")
        expect(presenter.further_information).to include("/government/organisations/department-of-health/about/publication-scheme")
        expect(presenter.further_information).to include("Personal information charter")
        expect(presenter.further_information).to include("/government/organisations/department-of-health/about/personal-information-charter")
      end
    end

    context "when there are no corporate information pages" do
      let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page_without_description") }

      it "returns nil" do
        expect(presenter.further_information).to be_nil
      end
    end
  end
end
