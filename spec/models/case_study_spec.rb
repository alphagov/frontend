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
        { "title" => organisations[1]["title"], "base_path" => organisations[1]["base_path"], "content_id" => organisations[1]["content_id"] },
        { "title" => organisations[0]["title"], "base_path" => organisations[0]["base_path"], "content_id" => organisations[0]["content_id"] },
        { "title" => worldwide_organisations[0]["title"], "base_path" => worldwide_organisations[0]["base_path"], "content_id" => worldwide_organisations[0]["content_id"] },
      ]

      expect(content_item.contributors).to eq(expected_contributors)
    end
  end
end
