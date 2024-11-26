RSpec.describe ThemeTypeHelper do
  include ThemeTypeHelper

  describe "no theme type" do
    it "returns theme type default when style is empty" do
      expect(style("")).to eq("theme-default")
    end
    it "returns theme type default when style is invalid" do
      expect(style("asdfghjkl")).to eq("theme-default")
    end
  end

  describe "theme 2" do
    it "returns theme type style 2" do
      expect(style(2)).to eq("theme-2")
    end
  end
end
