RSpec.describe CaseStudy do
  let(:content_store_response) do
    GovukSchemas::Example.find("case_study", example_name: "doing-business-in-spain")
  end

  it_behaves_like "it has updates", "case_study", "has-updates"
  it_behaves_like "it has no updates", "case_study", "doing-business-in-spain"
  it_behaves_like "it can have worldwide organisations", "case_study", "doing-business-in-spain"
  it_behaves_like "it can have emphasised organisations", "case_study", "doing-business-in-spain"

  describe "#contributors" do
    it "returns the organisations ordered by emphasis followed by worldwide organisations" do
      content_item = described_class.new(content_store_response)

      worldwide_organisations = content_store_response.dig("links", "worldwide_organisations")
      organisations = content_store_response.dig("links", "organisations")

      expected_contributors = [
        organisations[1],
        organisations[0],
        worldwide_organisations[0],
      ]

      expect(content_item.contributors).to eq(expected_contributors)
    end
  end
end
