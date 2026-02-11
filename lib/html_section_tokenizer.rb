class HtmlSectionTokenizer
  attr_reader :sections

  def initialize(body)
    @sections = parse_sections(body)
  end

  def intro
    sections.reject { |s| s.key?(:heading) }
  end

  def sections_with_heading
    sections.select { |s| s.key?(:heading) }
  end

private

  def parse_sections(body)
    return [] if body.blank?

    document = Nokogiri::HTML::DocumentFragment.parse(body)
    return [{ content: body }] if document.css("h2").count.zero?

    parts = []
    content = body.split("<h2").first
    parts << { content: } if content.present?

    parts + document.css("h2").map do |heading|
      content = []
      heading.xpath("following-sibling::*").each do |element|
        if element.name == "h2"
          break
        else
          content << element.to_html
        end
      end

      {
        heading: {
          text: heading.text,
          id: heading[:id],
        },
        content: content.join,
      }
    end
  end
end
