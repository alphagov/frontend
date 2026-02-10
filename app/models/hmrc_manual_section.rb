class HmrcManualSection < ContentItem
  include ManualLike

  attr_reader :section_id

  def initialize(content_store_response)
    super

    @section_id = details["section_id"]
  end
end
