require "html_section_tokenizer"

RSpec.describe HtmlSectionTokenizer do
  subject(:html_section_tokenizer) { described_class.new(body) }

  context "with an empty body" do
    let(:body) { "" }

    it "all methods return an empty array" do
      expect(html_section_tokenizer.intro).to eq([])
      expect(html_section_tokenizer.sections).to eq([])
      expect(html_section_tokenizer.sections_with_heading).to eq([])
    end
  end

  context "with no h2 sections" do
    let(:body) { "<p>Introduction</p>" }

    it "returns an array with one content element for #sections and #intro" do
      expect(html_section_tokenizer.intro).to eq([{ content: "<p>Introduction</p>" }])
      expect(html_section_tokenizer.sections).to eq([{ content: "<p>Introduction</p>" }])
    end

    it "returns an empty array for #sections_with_heading" do
      expect(html_section_tokenizer.sections_with_heading).to eq([])
    end
  end

  context "with multiple h2 sections" do
    let(:body) { "<h2 id=\"one\">1</h2>\n<p>Hello</p>\n<h2 id=\"two\">2</h2>\n<p>World</p>" }
    let(:expected) do
      [
        {
          heading: {
            text: "1",
            id: "one",
          },
          content: "<p>Hello</p>",
        },
        {
          heading: {
            text: "2",
            id: "two",
          },
          content: "<p>World</p>",
        },
      ]
    end

    it "returns an array with multiple elements with headings for #sections and #sections_with_heading" do
      expect(html_section_tokenizer.sections).to eq(expected)
      expect(html_section_tokenizer.sections_with_heading).to eq(expected)
    end

    it "returns an empty array for intro" do
      expect(html_section_tokenizer.intro).to eq([])
    end
  end

  context "with multiple h2 sections and an intro" do
    let(:body) { "<p>Introduction</p><h2 id=\"one\">1</h2>\n<p>Hello</p>\n<h2 id=\"two\">2</h2>\n<p>World</p>" }

    it "returns a content element for #intro" do
      expect(html_section_tokenizer.intro).to eq([{ content: "<p>Introduction</p>" }])
    end

    it "returns an array with one content element followed by multiple heading elements for #sections" do
      expect(html_section_tokenizer.sections).to eq([
        {
          content: "<p>Introduction</p>",
        },
        {
          heading: {
            text: "1",
            id: "one",
          },
          content: "<p>Hello</p>",
        },
        {
          heading: {
            text: "2",
            id: "two",
          },
          content: "<p>World</p>",
        },
      ])
    end

    it "returns two heading elements for #sections_with_heading" do
      expect(html_section_tokenizer.sections_with_heading).to eq([
        {
          heading: {
            text: "1",
            id: "one",
          },
          content: "<p>Hello</p>",
        },
        {
          heading: {
            text: "2",
            id: "two",
          },
          content: "<p>World</p>",
        },
      ])
    end
  end
end
