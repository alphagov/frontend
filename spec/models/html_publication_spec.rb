RSpec.describe HtmlPublication do
  subject(:html_publication) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("html_publication", example_name: "published") }

  it "returns a parent" do
    expect(html_publication.parent.content_id).to eq("8b19c238-54e3-4e27-b0d7-60f8e2a677c9")
  end
end
