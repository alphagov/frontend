RSpec.shared_examples "it can be linkable" do |document_type, example_name|
  before do
    @content_store_response = GovukSchemas::Example.find(document_type, example_name:)
  end

  it "knows it's linkable" do
    expect(described_class.new(@content_store_response).linkable_organisations).to eq(["<a class=\"govuk-link\" href=\"/government/organisations/department-for-environment-food-rural-affairs\">Department for Environment, Food &amp; Rural Affairs</a>"])
  end
end
