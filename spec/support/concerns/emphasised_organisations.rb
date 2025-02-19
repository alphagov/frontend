RSpec.shared_examples "it can have emphasised organisations" do |schema|
  let(:content_store_response) { GovukSchemas::Example.find(schema, example_name: schema) }

  it "knows it has emphasised organisations" do
    expect(described_class.new(content_store_response).contributors.first["content_id"]).to eq(content_store_response["details"]["emphasised_organisations"].first)
  end
end

RSpec.shared_examples "it can have organisations" do |schema|
  let(:content_store_response) { GovukSchemas::Example.find(schema, example_name: schema) }

  it "knows it has an organisations base_path, title and content_id" do
    expect(described_class.new(content_store_response).organisations).to eq(
      content_store_response["links"]["organisations"].map do |org|
        { "base_path" => org["base_path"], "title" => org["title"], "content_id" => org["content_id"] }
      end,
    )
  end
end
