RSpec.describe "News Article" do
  include Capybara::RSpecMatchers

  let(:content_item) { GovukSchemas::Example.find("news_article", example_name: "news_article") }
  let(:base_path) { content_item.fetch("base_path") }

  describe "GET show" do
    before do
      stub_content_store_has_item(base_path, content_item)

      get base_path
    end

    it "succeeds" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    it "sets cache-control headers" do
      expect(response).to honour_content_store_ttl
    end
  end
end
