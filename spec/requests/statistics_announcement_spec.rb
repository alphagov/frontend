RSpec.describe "StatisticsAnnouncement" do
  let(:content_item) { GovukSchemas::Example.find("statistics_announcement", example_name: "official_statistics") }
  let(:base_path) { content_item.fetch("base_path") }

  before do
    stub_content_store_has_item(base_path, content_item)
  end


  describe "GET show" do
    context "when visiting a Statistics Announcement page" do
      it "returns 200" do
        get base_path


        expect(response).to have_http_status(:ok)
      end


      it "renders the show template" do
        get base_path


        expect(response).to render_template("show")
      end
    end

  end
end