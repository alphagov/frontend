require "govspeak"

module GovspeakTranslatorHelper
  def parse_govspeak(block)
    doc = Govspeak::Document.new(block.strip)
    doc.to_html.strip
  end
end
