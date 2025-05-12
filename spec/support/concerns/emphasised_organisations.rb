RSpec.shared_examples "it can have emphasised organisations" do |document_type, example_name, data_source: :content_store|
  let(:content_item) { fetch_content_item(document_type, example_name, data_source:) }

  it "knows it has emphasised organisations" do
    first_organisation = content_item["links"]["organisations"].find do |link|
      link["content_id"] == content_item["details"]["emphasised_organisations"].first
    end

    expect(described_class.new(content_item).organisations_ordered_by_emphasis.first.title).to eq(first_organisation["title"])
  end
end

RSpec.shared_examples "it can have organisations" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has an organisations base_path, title and content_id" do
    expect(described_class.new(content_store_response).organisations).to eq(
      content_store_response["links"]["organisations"].map do |org|
        { "base_path" => org["base_path"], "title" => org["title"], "content_id" => org["content_id"] }
      end,
    )
  end
end
