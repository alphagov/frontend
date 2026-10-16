class PostalVoteVideoTranscript
  TRANSCRIPT_MARKER = "Transcript".freeze

  attr_reader :before_html, :transcript_html, :after_html

  def initialize(html)
    nodes = Nokogiri::HTML::DocumentFragment.parse(html).children.to_a

    transcript_index = nodes.index do |node|
      marker?(node, TRANSCRIPT_MARKER)
    end

    end_index = nodes.index do |node|
      marker?(
        node,
        PostalVoteVideoContentRemover::VIDEO_CONTENT_END_MARKER,
      )
    end

    return unless transcript_index && end_index
    return unless transcript_index < end_index

    @before_html = serialize(nodes.take(transcript_index))
    @transcript_html = serialize(nodes[(transcript_index + 1)...end_index])
    @after_html = serialize(nodes.drop(end_index))
  end

  def present?
    !transcript_html.nil?
  end

private

  def marker?(node, text)
    node.element? &&
      node.name == "p" &&
      node.text.gsub(/\s+/, " ").strip == text
  end

  def serialize(nodes)
    nodes.map(&:to_html).join
  end
end
