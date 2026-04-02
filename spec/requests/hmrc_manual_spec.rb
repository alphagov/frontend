RSpec.describe "HMRC Manual" do
  let(:content_item) { GovukSchemas::Example.find("hmrc_manual", example_name: "vat-government-public-bodies") }
  let(:base_path) { content_item.fetch("base_path") }

  before do
    stub_conditional_loader_does_not_return_content_item_for_path("/hmrc-internal-manuals")
    stub_conditional_loader_returns_content_item_for_path(base_path, content_item)
  end

  describe "GET show" do
    it "responds successfully" do
      get base_path
      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      get base_path
      expect(response).to render_template("show")
    end

    it "sets cache-control headers from the Content Store" do
      get base_path
      expect(response).to honour_content_store_ttl
    end
  end

  describe "GET updates" do
    let(:updates_path) { "#{base_path}/updates" }

    before do
      stub_conditional_loader_returns_content_item_for_path(updates_path, content_item)
    end

    it "responds successfully" do
      get updates_path
      expect(response).to have_http_status(:ok)
    end

    it "renders the updates template" do
      get updates_path
      expect(response).to render_template("updates")
    end

    it "sets cache-control headers from the Content Store" do
      get updates_path
      expect(response).to honour_content_store_ttl
    end
  end
end
