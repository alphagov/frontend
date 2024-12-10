RSpec.describe MetadataPresenter do
  describe "#metadata_component_options" do
    content_store_response = GovukSchemas::Example.find("case_study", example_name: "doing-business-in-spain")
    content_item = CaseStudy.new(content_store_response)

    let(:metadata_presenter) { described_class.new(content_item) }

    it "returns metadata with formatted dates and links" do
      expect(metadata_presenter.metadata_component_options).to eq({
        first_published: "21 March 2013",
        last_updated: nil,
        from: ["<a class=\"govuk-link\" href=\"/government/organisations/uk-trade-investment\">UK Trade &amp; Investment</a>", "<a class=\"govuk-link\" href=\"/government/organisations/foreign-commonwealth-office\">Foreign &amp; Commonwealth Office</a>", "<a class=\"govuk-link\" href=\"/world/organisations/british-embassy-madrid\">British Embassy Madrid</a>"],
        see_updates_link: true,
      })
    end
  end
end
