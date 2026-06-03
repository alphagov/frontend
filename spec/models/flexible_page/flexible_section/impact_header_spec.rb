RSpec.describe FlexiblePage::FlexibleSection::ImpactHeader do
  subject(:impact_header) { described_class.new(description:, image:, title:, variant:) }

  let(:title) { "This is the page H1" }
  let(:description) { "This is the lead paragraph" }
  let(:image) do
    {
      caption: "Test data",
      sources: {
        desktop: "https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg",
        desktop_2x: "https://assets.publishing.service.gov.uk/media/67472570cf0d45234dd8d0a8/hero_desktop_2x_F_Desktop_HD-50.jpg",
        mobile: "https://assets.publishing.service.gov.uk/media/67472591a72d7eb7f348c047/hero_mobile_1x_F_MOBILE_HD-50.jpg",
        mobile_2x: "https://assets.publishing.service.gov.uk/media/674725912f94bef8ff48c044/hero_mobile_2x_F_MOBILE_HD-50.jpg",
        tablet: "https://assets.publishing.service.gov.uk/media/6747258077462f78091474e2/hero_tablet_1x_F_Tablet_HD-50.jpg",
        tablet_2x: "https://assets.publishing.service.gov.uk/media/67472580886c31e352d8d0b1/hero_tablet_2x_F_Tablet_HD-50.jpg",
      },
    }
  end
  let(:variant) { "govuk" }

  describe "when complete data is provided" do
    it "includes page title and description" do
      expect(impact_header.title).to eq("This is the page H1")
      expect(impact_header.description).to eq("This is the lead paragraph")
    end

    it "returns image information" do
      expect(impact_header.image).to eq({
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
      expect(impact_header.caption).to eq({
        caption_text: "Test data",
        theme: "black",
        inverse: nil,
      })
    end
  end

  describe "when it contains a logo" do
    subject(:impact_header) { described_class.new(description:, image:, image_type: "logo", title:, variant:) }

    it "does not return a caption" do
      expect(impact_header.caption).to be_nil
    end
  end

  describe "when the variant is notable-death" do
    let(:variant) { "notable-death" }

    it "sets the caption inverse value to true" do
      expect(impact_header.caption[:inverse]).to be(true)
      expect(impact_header.caption[:theme]).to be_nil
    end
  end

  describe "when there is no image" do
    subject(:impact_header) { described_class.new(description:, title:, variant:) }

    it "returns only the text content" do
      expect(impact_header.title).to eq("This is the page H1")
      expect(impact_header.description).to eq("This is the lead paragraph")
      expect(impact_header.image).to be_nil
      expect(impact_header.caption).to be_nil
    end
  end

  describe "when there is no caption" do
    let(:image) do
      {
        caption: "",
        sources: {
          desktop: "https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg",
          desktop_2x: "https://assets.publishing.service.gov.uk/media/67472570cf0d45234dd8d0a8/hero_desktop_2x_F_Desktop_HD-50.jpg",
        },
      }
    end

    it "returns no caption" do
      expect(impact_header.caption).to be_nil
    end
  end
end
