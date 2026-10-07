class PostalVoteVideoContentRemover
  YOUTUBE_URL_PATTERN = %r{\Ahttps?://(?:(?:www\.)?youtube\.com|youtu\.be)/}i
  PUNCTUATION_PATTERN = /[.!?"']/
  VIDEO_CONTENT_END_MARKER = "You must apply for a postal vote if you want to vote by post, for example if:".freeze

  def initialize(html)
    @fragment = Nokogiri::HTML::DocumentFragment.parse(html)
  end

  def remove
    youtube_links.each do |link|
      remove_video_content(link) if standalone_video_link?(link)
    end

    @fragment.to_html
  end

private

  def youtube_links
    @fragment.css("a[href]").select do |link|
      link["href"].match?(YOUTUBE_URL_PATTERN) &&
        link["data-youtube-player"] != "off" &&
        !link["href"].include?("/playlist")
    end
  end

  def standalone_video_link?(link)
    paragraph = link.parent
    return false unless paragraph.name == "p"

    without_punctuation(paragraph.inner_html) == without_punctuation(link.to_html)
  end

  # Govspeak also ignores surrounding punctuation when deciding whether a
  # YouTube link is standalone and should be expanded into an embedded video.
  def without_punctuation(html)
    html.gsub(PUNCTUATION_PATTERN, "").strip
  end

  def remove_video_content(link)
    video_paragraph = link.parent
    following_elements = video_paragraph.xpath("following-sibling::*")
    end_index = following_elements.index { |element| video_content_end?(element) }

    elements = [video_paragraph]
    elements.concat(following_elements.take(end_index)) unless end_index.nil?
    elements.each(&:remove)
  end

  # The experimental content is inserted immediately before this existing
  # paragraph. Keep the paragraph itself and everything that follows it.
  def video_content_end?(element)
    element.name == "p" &&
      element.text.gsub(/\s+/, " ").strip == VIDEO_CONTENT_END_MARKER
  end
end
