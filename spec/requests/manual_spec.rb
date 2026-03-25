RSpec.describe "Manual" do
  let(:content_item) { GovukSchemas::Example.find("manual", example_name: "content-design") }
  let(:base_path) { content_item.fetch("base_path") }

  before do
    stub_conditional_loader_does_not_return_content_item_for_path("/guidance")
    stub_conditional_loader_returns_content_item_for_path(base_path, content_item)
  end

  describe "GET show" do
    context "when visiting Manual page" do
      it "shows the manual page" do
        get base_path

        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        get base_path

        expect(response).to render_template("show")
      end
    end

    context "when visiting Manual updates page" do
      let(:updates_path) { "#{base_path}/updates" }

      before do
        stub_conditional_loader_returns_content_item_for_path(updates_path, content_item)
      end

      it "shows the manual updates page" do
        get updates_path
        expect(response).to have_http_status(:ok)
      end

      it "renders the manual updates template" do
        get updates_path
        expect(response).to render_template("manual_updates")
      end
    end
  end
end
