class ManualSection < ContentItem
  include ManualSections
  include ManualLike

  attr_reader :intro, :sections

  def initialize(content_store_response)
    super

    section_tokenizer = HtmlSectionTokenizer.new(body)
    @intro = section_tokenizer.intro.first&.dig(:content)
    @sections = section_tokenizer.sections_with_heading
  end

  def contents_outline
    ContentsOutline.new(sections.map { |section| section[:heading].stringify_keys })
  end

  def visually_expanded?
    content_store_response.dig("details", "visually_expanded") == "true"
  end
end
