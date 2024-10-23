class GetInvolved < ContentItem
  attr_reader :take_part_pages

  def initialize(content_store_response, override_content_store_hash: nil)
    super(content_store_response, override_content_store_hash:)
    @take_part_pages = content_store_hash.dig("links", "take_part_pages")
  end
end
