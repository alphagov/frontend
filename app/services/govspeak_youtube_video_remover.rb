class GovspeakYoutubeVideoRemover
  YOUTUBE_URL_PATTERN = %r{\Ahttps?://(?:(?:www\.)?youtube\.com|youtu\.be)/}i
  PUNCTUATION_PATTERN = /[.!?"']/

  def initialize(html)
    @fragment = Nokogiri::HTML::DocumentFragment.parse(html)
  end

  def remove
    youtube_links.each do |link|
      link.parent.remove if standalone_video_link?(link)
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
end
