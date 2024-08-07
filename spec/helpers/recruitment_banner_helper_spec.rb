RSpec.describe RecruitmentBannerHelper do
  include RecruitmentBannerHelper

  before do
    @recruitment_banners_data = YAML.load_file(Rails.root.join("spec/fixtures/recruitment_banners.yml"))
  end

  def request
    OpenStruct.new(path: "/")
  end

  def recruitment_banners
    @recruitment_banners_data["banners"]
  end

  describe "#recruitment_banner" do
    it "returns banners that include the current url" do
      expected_banners = {
        "name" => "Banner 1",
        "suggestion_text" => "Help improve GOV.UK",
        "suggestion_link_text" => "Take part in user research",
        "survey_url" => "https://google.com",
        "page_paths" => ["/"],
      }

      expect(recruitment_banner).to eq(expected_banners)
    end
  end

  it "recruitment_banners yaml structure is valid" do
    @recruitment_banners_data = YAML.load_file(Rails.root.join("lib/data/recruitment_banners.yml"))

    if @recruitment_banners_data["banners"].present?
      recruitment_banners.each do |banner|
        expect(banner.key?("suggestion_text")).to be true
        expect(banner["suggestion_text"]).not_to be_empty
        expect(banner.key?("suggestion_link_text")).to be true
        expect(banner["suggestion_link_text"]).not_to be_empty
        expect(banner.key?("survey_url")).to be true
        expect(banner["survey_url"]).not_to be_empty
        expect(banner.key?("page_paths")).to be true
        expect(banner["page_paths"]).not_to be_empty
      end
    end
  end
end
