RSpec.describe DetailedGuidePresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide") }
  let(:content_item) { DetailedGuide.new(content_store_response) }

  describe "#headers_for_contents_list_component" do
    context "when there are headers in the details hash" do
      it "returns an array of H2 headers" do
        expect(presenter.headers_for_contents_list_component).not_to be_empty
      end

      it "does not include nested h3s in the array" do
        content_store_response["details"]["headers"] = [
          { "text" => "Overview",
            "level" => 2,
            "id" => "overview",
            "headers" => [
              { "text" => "Example overview",
                "level" => 3,
                "id" => "example-overview" },
            ] },
          { "text" => "Renewal grants",
            "level" => 2,
            "id" => "renewal-grants",
            "headers" => [
              { "text" => "Example renewal grants",
                "level" => 3,
                "id" => "example-renewal-grants" },
            ] },
        ]

        contents_list_headings = presenter.headers_for_contents_list_component

        contents_list_headings.each do |heading|
          expect(heading[:items]).to be_empty
        end
      end
    end

    context "when there are no headers in the details hash" do
      let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "best-practice-detailed-guide") }

      it "returns an empty array" do
        expect(presenter.headers_for_contents_list_component).to be_empty
      end
    end
  end
end
