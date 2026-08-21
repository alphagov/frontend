RSpec.describe "Person pages" do
  include SchemaOrgHelpers
  include GdsApi::TestHelpers::Search

  let(:content_store_response) do
    GovukSchemas::RandomExample.for_schema(frontend_schema: "person").merge(
      "title" => "Rufus Scrimgeour",
      "description" => "Minister for Magic and former Head of the Auror Office.",
      "base_path" => "/government/people/rufus-scrimgeour",
    )
  end
  let(:base_path) { content_store_response.fetch("base_path") }

  before do
    stub_conditional_loader_returns_content_item_for_path(base_path, content_store_response)
    stub_any_search_to_return_no_results
    visit base_path
  end

  it "displays the person name" do
    expect(page).to have_css("h1", text: "Rufus Scrimgeour")
  end

  it "sets the page title" do
    expect(page).to have_title("Rufus Scrimgeour - GOV.UK")
  end

  it "sets the page meta description" do
    expect(page).to have_selector(
      "meta[name='description'][content='Minister for Magic and former Head of the Auror Office.']",
      visible: :hidden,
    )
  end

  it "includes Person machine-readable metadata" do
    person_schema = find_schema_of_type("Person")

    expect(person_schema).not_to be_nil
    expect(person_schema["name"]).to eq("Rufus Scrimgeour")
  end
end
