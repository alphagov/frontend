RSpec.describe HowGovernmentWorksPresenter do
  subject(:how_government_works_presenter) { described_class.new(content_item) }

  let(:content_item) { HowGovernmentWorks.new(content_store_response) }

  describe "#agencies_and_other_public_bodies" do
    let(:content_store_response) do
      GovukSchemas::Example.find("how_government_works", example_name: "reshuffle-mode-off").tap do |item|
        item["details"]["department_counts"]["agencies_and_public_bodies"] = "432"
      end
    end

    it "returns the figure truncated with a plus sign" do
      expect(how_government_works_presenter.agencies_and_other_public_bodies).to eq("400+")
    end

    it "uses contextual components" do
      expect(how_government_works_presenter.use_contextual_components?).to be(true)
    end

    it "returns the contents list array" do
      expect(how_government_works_presenter.contents_list).to eq([
        {
          href: "#who-runs-government",
          text: "Who runs government",
        },
        {
          href: "#how-government-is-run",
          text: "How government is run",
        },
        {
          href: "#civil-service",
          text: "Civil service",
        },
        {
          href: "#get-involved",
          text: "Get involved",
        },
        {
          href: "#legislation",
          text: "Legislation",
        },
        {
          href: "#access-to-information",
          text: "Access to information",
        },
        {
          href: "#devolved-government",
          text: "Devolved government",
        },
        {
          href: "#local-government",
          text: "Local government",
        },
        {
          href: "#parliament",
          text: "Parliament",
        },
        {
          href: "#history-uk-government",
          text: "History of government",
        },
      ])
    end
  end
end
