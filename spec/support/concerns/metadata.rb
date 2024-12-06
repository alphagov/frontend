RSpec.shared_examples "it can have metadata" do |document_type, example_name|
  before do
    @content_store_response = GovukSchemas::Example.find(document_type, example_name:)
  end

  it "knows it's publisher_metadata" do
    expect(described_class.new(@content_store_response).publisher_metadata).to eq({
      first_published: "2012-09-12T10:00:00+01:00",
      from: ["<a class=\"govuk-link\" href=\"/government/organisations/department-for-environment-food-rural-affairs\">Department for Environment, Food &amp; Rural Affairs</a>"],
      last_updated: "2016-02-18T15:45:44.000+00:00",
      see_updates_link: true,
    })
  end
end
