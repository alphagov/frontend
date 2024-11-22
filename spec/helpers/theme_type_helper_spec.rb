RSpec.describe ThemeTypeHelper do
  include ThemeTypeHelper

  describe "no theme type" do
    it "returns theme type style 1" do
      expect(style("")).to eq("theme-1")
    end
  end

  describe "theme 2" do
    it "returns theme type style 2" do
      expect(style(2)).to eq("theme-2")
    end
  end
end
