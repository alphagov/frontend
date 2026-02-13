RSpec.describe FlexiblePage::FlexibleSection::ImpactHeader do
  header = {
    "title" => "This is the page H1",
    "description" => "This is the lead paragraph",
    "breadcrumbs" => [
      {
        "title" => "Home",
        "url" => "/",
      },
    ],
    "image" => {
      "alt_text" => "image alt text",
      "sources" => {
        "desktop" => "https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg",
        "desktop_2x" => "https://assets.publishing.service.gov.uk/media/67472570cf0d45234dd8d0a8/hero_desktop_2x_F_Desktop_HD-50.jpg",
        "mobile" => "https://assets.publishing.service.gov.uk/media/67472591a72d7eb7f348c047/hero_mobile_1x_F_MOBILE_HD-50.jpg",
        "mobile_2x" => "https://assets.publishing.service.gov.uk/media/674725912f94bef8ff48c044/hero_mobile_2x_F_MOBILE_HD-50.jpg",
        "tablet" => "https://assets.publishing.service.gov.uk/media/6747258077462f78091474e2/hero_tablet_1x_F_Tablet_HD-50.jpg",
        "tablet_2x" => "https://assets.publishing.service.gov.uk/media/67472580886c31e352d8d0b1/hero_tablet_2x_F_Tablet_HD-50.jpg",
      },
    },
  }

  header_without_image = {
    "title" => "Page title",
    "description" => "description",
    "breadcrumbs" => [
      {
        "title" => "Home",
        "url" => "/",
      },
    ],
  }

  subject(:content_hash) do
    header
  end

  let(:impact) { described_class.new(content_hash, FlexiblePage.new({})) }

  describe "when complete data is provided" do
    it "includes page title and description" do
      expect(impact.breadcrumbs).to eq([{ title: "Home", url: "/" }])
      expect(impact.title).to eq("This is the page H1")
      expect(impact.description).to eq("This is the lead paragraph")
    end

    it "returns image information" do
      expect(impact.image).to eq({
        alt_text: "image alt text",
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
  end

  describe "when there is no image" do
    let(:content_hash) do
      header_without_image
    end

    it "returns only the text content" do
      expect(impact.breadcrumbs).to eq([{ title: "Home", url: "/" }])
      expect(impact.title).to eq("Page title")
      expect(impact.description).to eq("description")
      expect(impact.image).to be(false)
    end
  end
end
