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
