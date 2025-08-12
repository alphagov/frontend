RSpec.describe "Publication Data Set" do
  let(:base_path) { "/government/publications/d17-9ly-veolia-es-uk-limited-environmental-permit-issued" }

  before do
    content_store_has_example_item(base_path, schema: :publication)
  end

  describe "GET show" do
    context "when visiting a Publication page" do
      it "returns 200" do
        get base_path

        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        get base_path

        expect(response).to render_template("show")
      end

      context "when the path is under /government/statistics" do
        let(:base_path) { "/government/statistics/d17-9ly-veolia-es-uk-limited-environmental-permit-issued" }

        it "returns 200" do
          get base_path

          expect(response).to have_http_status(:ok)
        end
      end

      context "when the path should be hidden from search engines" do
        let(:base_path) { "/government/publications/govuk-app-testing-privacy-notice-how-we-use-your-data" }

        it "returns the page with noindex meta tags" do
          get base_path

          expect(response.body).to include('<meta name="robots" content="noindex">')
        end
      end
    end
  end
end
