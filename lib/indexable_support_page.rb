require "nokogiri"

class IndexableSupportPage
  def initialize(filename)
    @filename = filename
    @io = File.read(filename)
  end

  def title
    html.at_css("h1").inner_text
  end

  def description
    # Not yet implemented, intention is to use a meta-description
    nil
  end

  def format
    "support_page"
  end

  def link
     basename = File.basename(@filename)
     filename_without_extensions = basename.gsub(/(\.erb|\.html\.erb)$/, "")
    "/support/#{filename_without_extensions}"
  end

  def indexable_content
    # The one downside to pretending the file is straight HTML is that it
    # includes any source code from inside erb blocks, eg classes added to
    # the body inside a content_for. This doesn't seem like a big deal.
    html.inner_text
  end

  def to_hash
    {
      "title" => title,
      "description" => description,
      "format" => format,
      "link" => link,
      "indexable_content" => indexable_content
    }
  end

private
  def html
    @_html ||= Nokogiri::HTML.parse(@io)
  end
end