RSpec.describe "Person pages" do
  include GdsApi::TestHelpers::Search

  describe "GET show" do
    let(:content_item) do
      GovukSchemas::RandomExample.for_schema(frontend_schema: "person").merge(
        "title" => "Rufus Scrimgeour",
        "base_path" => "/government/people/rufus-scrimgeour",
      )
    end
    let(:base_path) { content_item.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_item)
      stub_any_search_to_return_no_results
      get base_path
    end

    it "returns successfully" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the people show template" do
      expect(response).to render_template("people/show")
    end

    it "sets public cache headers" do
      expect(response.headers["Cache-Control"]).to include("public")
    end
  end
end
