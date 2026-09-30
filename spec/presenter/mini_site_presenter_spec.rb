RSpec.describe MiniSitePresenter do
  include SharedContexts::ContentItemImageArrays

  subject(:mini_site_presenter) { described_class.new(content_item) }

  let(:content_item) { MiniSite.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("mini_site", example_name:) }
  let(:example_name) { "mini-site" }
  let(:schema_name) { "mini_site" }

  it_behaves_like "it can present a document feed", "mini_site", "mini-site"
  it_behaves_like "it can present an impact header", "mini_site", "mini-site"
  it_behaves_like "it can present an involved list", "mini_site", "mini-site"
  it_behaves_like "it can present ordered featured documents", "mini_site", "mini-site"
  it_behaves_like "it can present service navigation items", "mini_site", "mini-site"

  describe "#body_with_image?" do
    context "when there is only a header" do
      include_context "when details/images has a single image of type ", "header"

      it "returns false" do
        expect(mini_site_presenter.body_with_image?).to be false
      end
    end

    context "when there is only a logo" do
      include_context "when details/images has a single image of type ", "logo"

      it "returns false" do
        expect(mini_site_presenter.body_with_image?).to be false
      end
    end

    context "when header and logo are present" do
      include_context "when details/images has multiple images of types ", %w[header logo]

      it "returns true" do
        expect(mini_site_presenter.body_with_image?).to be true
      end
    end
  end

  describe "formatted_social_media_links" do
    it "returns the links simplified and formatted" do
      expect(mini_site_presenter.formatted_social_media_links.count).to eq(2)
      expect(mini_site_presenter.formatted_social_media_links.first.keys).to eq(%i[href icon text])
    end
  end

  describe "#impact_header_image" do
    it "returns the header image" do
      expect(mini_site_presenter.impact_header_image[:type]).to eq("header")
    end

    context "when there is no header image" do
      include_context "when details/images has a single image of type ", "logo"

      it "returns the logo image" do
        expect(mini_site_presenter.impact_header_image[:type]).to eq("logo")
      end
    end

    context "when there are no header or logo images" do
      include_context "with no details/images"

      it "returns nil" do
        expect(mini_site_presenter.impact_header_image).to be_nil
      end
    end
  end

  describe "#impact_header_image_type" do
    it "returns header" do
      expect(mini_site_presenter.impact_header_image_type).to eq("header")
    end

    context "when there is no header image" do
      include_context "when details/images has a single image of type ", "logo"

      it "returns logo" do
        expect(mini_site_presenter.impact_header_image_type).to eq("logo")
      end
    end
  end
end
