class ManualSection < ContentItem
  include ManualSections
  include ManualLike

  attr_reader :intro, :sections

  delegate :for_contextual_breadcrumbs, to: :manual_content_item

  def initialize(content_store_response)
    super

    section_tokenizer = HtmlSectionTokenizer.new(body)
    @intro = section_tokenizer.intro.first&.dig(:content)
    @sections = section_tokenizer.sections_with_heading
  end
end
