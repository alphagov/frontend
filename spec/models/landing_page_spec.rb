RSpec.describe LandingPage do
  subject(:landing_page) { described_class.new(landing_page_example) }

  let(:landing_page_example) { GovukSchemas::Example.find(:landing_page, example_name: :landing_page) }

  describe "#blocks" do
    it "builds all of the blocks" do
      expect(landing_page.blocks.count).to eq(landing_page_example["details"]["blocks"].count)
    end

    it "builds blocks of the correct type" do
      expect(landing_page.blocks.first.type).to eq(landing_page_example["details"]["blocks"].first["type"])
    end
  end

  describe "#navigation_groups" do
    it "returns a map of navigation_groups" do
      expect(landing_page.navigation_groups["Top Menu"]["id"]).to eq("Top Menu")
      expect(landing_page.navigation_groups["Top Menu"]["links"].count).to eq(2)
      expect(landing_page.navigation_groups["Top Menu"]["links"][0]["links"].count).to eq(2)
    end
  end

  describe "#breadcrumbs" do
    it "returns nil if there are no breadcrumbs" do
      landing_page_example["details"]["breadcrumbs"] = nil

      expect(landing_page.breadcrumbs).to be_nil
    end

    it "returns breadcrumbs in the structure expected by govuk_publishing_components" do
      # Note the config in the YAML file is { "title" => ..., "href" => ... } rather than { title: ..., url: ...}
      # this is for consistency with the blocks, which tend to use href for their URLs.
      expect(landing_page.breadcrumbs).to eq([
        { title: "Some breadcrumb", url: "/some-breadcrumb" },
        { title: "Some other breadcrumb", url: "/some-other-breadcrumb" },
      ])
    end
  end

  describe "#theme" do
    it "returns the default theme if theme is default" do
      expect(landing_page.theme).to eq("default")
    end

    it "returns the default theme if theme is not specified" do
      landing_page_example["details"]["theme"] = nil

      expect(landing_page.theme).to eq("default")
    end

    it "returns the default theme if theme is not in the list of accepted themes" do
      landing_page_example["details"]["theme"] = "missing-theme"

      expect(landing_page.theme).to eq("default")
    end

    it "returns the specified theme if theme is in the list of accepted themes" do
      landing_page_example["details"]["theme"] = "prime-ministers-office-10-downing-street"

      expect(landing_page.theme).to eq("prime-ministers-office-10-downing-street")
    end
  end
end
