RSpec.describe "Topical Event pages" do
  include GdsApi::TestHelpers::Search

  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018") }
  let(:base_path) { content_store_response.fetch("base_path") }

  before do
    stub_content_store_has_item(base_path, content_store_response)
    stub_any_search_to_return_no_results
    visit base_path
  end

  it "sets the page title" do
    expect(page).to have_title("#{content_store_response['title']} - GOV.UK")
  end

  it "sets the page description" do
    expect(page).to have_text(content_store_response["description"])
  end

  it "sets the page meta description" do
    expect(page).to have_selector("meta[name='description'][content='#{content_store_response['description']}']", visible: :hidden)
  end

  it "includes an impact header" do
    expect(page).to have_selector("[data-flexible-section='impact-header']")
  end

  it "sets the body text" do
    expect(page.html).to include(content_store_response.dig("details", "body"))
  end

  it "includes a link to the about page" do
    expect(page).to have_link(content_store_response.dig("details", "about_page_link_text"), href: "#{base_path}/about")
  end

  it "includes featured documents" do
    expect(page).to have_selector("[data-flexible-section='featured']")
  end

  it "includes a feed document list" do
    expect(page).to have_selector("[data-flexible-section='feed_document_list']")
  end

  it "includes an involved block" do
    expect(page).to have_selector("[data-flexible-section='involved']")
  end
end
