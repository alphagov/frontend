RSpec.describe GovspeakTranslatorHelper do
  describe "#parse_govspeak" do
    it "converts simple govspeak into markup" do
      str = "#heading"
      expect(parse_govspeak(str)).to eq("<h1 id=\"heading\">heading</h1>")
    end

    it "converts multi line govspeak into markup" do
      str = "
#heading

This is a paragraph
      "
      expect(parse_govspeak(str)).to eq("<h1 id=\"heading\">heading</h1>\n\n<p>This is a paragraph</p>")
    end

    it "ignores formatting" do
      str = "\n\t\t\t#heading\n\n\t"
      expect(parse_govspeak(str)).to eq("<h1 id=\"heading\">heading</h1>")
    end
  end
end
