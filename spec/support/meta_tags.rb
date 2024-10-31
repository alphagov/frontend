RSpec.shared_examples "it has meta tags" do |schema, base_path|
  before do
    example_doc = GovukSchemas::RandomExample.for_schema(frontend_schema: schema) do |random|
      random.merge!(
        "title" => "Zhe title",
        "withdrawn_notice" => {},
      )
      random["links"]["available_translations"] = []
      random
    end

    stub_content_store_has_item("#{base_path}/some-page", example_doc.to_json)
  end

  it "renders the correct meta tags for the title" do
    visit "#{base_path}/some-page"

    expect(page).to have_css("meta[property='og:title'][content='Zhe title']", visible: false)
  end
end

RSpec.shared_examples "it has meta tags for images" do |schema, base_path|
  before do
    example_doc = GovukSchemas::RandomExample.for_schema(frontend_schema: schema) do |random|
      random["details"].merge!(
        "image" => {
          "url" => "https://example.org/image.jpg",
          "alt_text" => "An accessible alt text",
        },
      )
      random["links"]["available_translations"] = []
      random
    end

    stub_content_store_has_item("#{base_path}/some-page", example_doc.to_json)
  end

  it "renders image tags" do
    visit "#{base_path}/some-page"

    expect(page).to have_css("meta[name='twitter:card'][content='summary_large_image']", visible: false)
    expect(page).to have_css("meta[name='twitter:image'][content='https://example.org/image.jpg']", visible: false)
    expect(page).to have_css("meta[property='og:image'][content='https://example.org/image.jpg']", visible: false)
  end
end
