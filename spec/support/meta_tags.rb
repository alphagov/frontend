RSpec.shared_examples "it has meta tags" do |schema, path|
  before do
    example_doc = GovukSchemas::Example.find(schema, example_name: schema)
    example_doc.merge!(
      "title" => "Zhe title",
      "withdrawn_notice" => {},
    )
    example_doc["links"]["available_translations"] = []

    stub_content_store_has_item(path, example_doc.to_json)
  end

  it "renders the correct meta tags for the title" do
    visit path

    expect(page).to have_css("meta[property='og:title'][content='Zhe title']", visible: false)
  end
end

RSpec.shared_examples "it has meta tags for images" do |schema, path|
  before do
    example_doc = GovukSchemas::Example.find(schema, example_name: schema)
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

    expect(page).to have_css("meta[name='twitter:card'][content='summary_large_image']", visible: false)
    expect(page).to have_css("meta[name='twitter:image'][content='https://example.org/image.jpg']", visible: false)
    expect(page).to have_css("meta[property='og:image'][content='https://example.org/image.jpg']", visible: false)
  end
end
