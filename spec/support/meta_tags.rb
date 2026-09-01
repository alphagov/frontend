RSpec.shared_examples "it has meta tags" do |schema, example|
  let(:example_doc) { GovukSchemas::Example.find(schema, example_name: example) }
  let(:path) { example_doc["base_path"] }

  before do
    example_doc.merge!(
      "title" => "Zhe title",
      "withdrawn_notice" => {},
    )
    example_doc["links"]["available_translations"] = []

    stub_content_store_has_item(path, example_doc.to_json)
  end

  it "renders the correct meta tags for the title" do
    visit path

    expect(page).to have_css("meta[property='og:title'][content='Zhe title']", visible: :hidden)
  end
end

RSpec.shared_examples "it has meta tags for images" do |schema, example|
  let(:example_doc) { GovukSchemas::Example.find(schema, example_name: example) }
  let(:path) { example_doc["base_path"] }

  before do
    example_doc["details"].merge!(
      "image" => {
        "url" => "https://example.org/image.jpg",
        "alt_text" => "An accessible alt text",
      },
    )
    example_doc["links"]["available_translations"] = []

    stub_content_store_has_item(path, example_doc.to_json)
  end

  it "renders image tags" do
    visit path

    expect(page).to have_css("meta[name='twitter:card'][content='summary_large_image']", visible: :hidden)
    expect(page).to have_css("meta[name='twitter:image'][content='https://example.org/image.jpg']", visible: :hidden)
    expect(page).to have_css("meta[property='og:image'][content='https://example.org/image.jpg']", visible: :hidden)
  end
end
