RSpec.describe FlexiblePage::FlexibleSection::ImpactHeader do
  header = {
    "title" => "This is the page H1",
    "description" => "This is the lead paragraph",
    "image" => {
      "caption" => "Test data",
      "sources" => {
        "desktop" => "https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg",
        "desktop_2x" => "https://assets.publishing.service.gov.uk/media/67472570cf0d45234dd8d0a8/hero_desktop_2x_F_Desktop_HD-50.jpg",
        "mobile" => "https://assets.publishing.service.gov.uk/media/67472591a72d7eb7f348c047/hero_mobile_1x_F_MOBILE_HD-50.jpg",
        "mobile_2x" => "https://assets.publishing.service.gov.uk/media/674725912f94bef8ff48c044/hero_mobile_2x_F_MOBILE_HD-50.jpg",
        "tablet" => "https://assets.publishing.service.gov.uk/media/6747258077462f78091474e2/hero_tablet_1x_F_Tablet_HD-50.jpg",
        "tablet_2x" => "https://assets.publishing.service.gov.uk/media/67472580886c31e352d8d0b1/hero_tablet_2x_F_Tablet_HD-50.jpg",
      },
    },
    "variant" => "govuk",
  }

  header_without_image = {
    "title" => "Page title",
    "description" => "description",
    "image_caption" => "this should not render",
  }

  header_with_logo = {
    "title" => "Page title",
    "description" => "description",
    "image_type" => "logo",
  }

  header_notable_death_variant = header.clone
  header_notable_death_variant["variant"] = "notable-death"

  subject(:content_hash) do
    header
  end

  let(:impact) { described_class.new(content_hash, FlexiblePage.new({})) }

  describe "when complete data is provided" do
    it "includes page title and description" do
      expect(impact.title).to eq("This is the page H1")
      expect(impact.description).to eq("This is the lead paragraph")
    end

    it "returns image information" do
      expect(impact.image).to eq({
        caption: "Test data",
        sources: {
          desktop: "https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg",
          desktop_2x: "https://assets.publishing.service.gov.uk/media/67472570cf0d45234dd8d0a8/hero_desktop_2x_F_Desktop_HD-50.jpg",
          mobile: "https://assets.publishing.service.gov.uk/media/67472591a72d7eb7f348c047/hero_mobile_1x_F_MOBILE_HD-50.jpg",
          mobile_2x: "https://assets.publishing.service.gov.uk/media/674725912f94bef8ff48c044/hero_mobile_2x_F_MOBILE_HD-50.jpg",
          tablet: "https://assets.publishing.service.gov.uk/media/6747258077462f78091474e2/hero_tablet_1x_F_Tablet_HD-50.jpg",
          tablet_2x: "https://assets.publishing.service.gov.uk/media/67472580886c31e352d8d0b1/hero_tablet_2x_F_Tablet_HD-50.jpg",
        },
      })
    end

    it "returns the correct caption information" do
      allow(SecureRandom).to receive(:hex).and_return("1234")
      expect(impact.caption).to eq({
        caption_text: "Test data",
        caption_id: "impact-header__image-id-1234",
        theme: "black",
        inverse: nil,
      })
    end

    it "does not generate a new caption id each time caption is called" do
      id = impact.caption[:caption_id]
      expect(impact.caption[:caption_id]).to eq(id)
    end
  end

  describe "when it contains a logo" do
    let(:content_hash) do
      header_with_logo
    end

    it "does not return a caption" do
      expect(impact.caption).to be_nil
    end
  end

  describe "when the variant is notable-death" do
    let(:content_hash) do
      header_notable_death_variant
    end

    it "sets the caption inverse value to true" do
      expect(impact.caption[:inverse]).to be(true)
      expect(impact.caption[:theme]).to be_nil
    end
  end

  describe "when there is no image" do
    let(:content_hash) do
      header_without_image
    end

    it "returns only the text content" do
      expect(impact.title).to eq("Page title")
      expect(impact.description).to eq("description")
      expect(impact.image).to be(false)
      expect(impact.caption).to be_nil
    end
  end
end
