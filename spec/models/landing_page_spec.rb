RSpec.describe LandingPage do
  include ContentItemHelpers

  subject(:landing_page) { content_item_from_factory(content_item_hash:) }

  let(:content_item_hash) { GovukSchemas::Example.find(:landing_page, example_name: :landing_page) }

  describe "#blocks" do
    it "builds all of the blocks" do
      expect(landing_page.blocks.count).to eq(content_item_hash.dig("details", "blocks").count)
    end

    it "builds blocks of the correct type" do
      expect(landing_page.blocks.first.type).to eq(content_item_hash.dig("details", "blocks", 0, "type"))
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
      content_item_hash["details"].delete("breadcrumbs")

      expect(landing_page.breadcrumbs).to be_nil
    end

    it "returns breadcrumbs in the structure expected by govuk_publishing_components" do
      # Note the config in the content item details is { "title" => ..., "href" => ... } rather than
      # { title: ..., url: ...} this is for consistency with the blocks, which tend to use href for
      # their URLs.
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
      content_item_hash["details"]["theme"] = nil

      expect(landing_page.theme).to eq("default")
    end

    it "returns the default theme if theme is not in the list of accepted themes" do
      content_item_hash["details"]["theme"] = "missing-theme"

      expect(landing_page.theme).to eq("default")
    end

    it "returns the specified theme if theme is in the list of accepted themes" do
      content_item_hash["details"]["theme"] = "prime-ministers-office-10-downing-street"

      expect(landing_page.theme).to eq("prime-ministers-office-10-downing-street")
    end
  end
end
