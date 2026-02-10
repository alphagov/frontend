class HmrcManualSection < ContentItem
  include ManualLike

  attr_reader :child_section_groups, :section_id

  def initialize(content_store_response)
    super

    @child_section_groups = details["child_section_groups"]
    @section_id = details["section_id"]
  end

  def next_sibling
    nil
  end

  def previous_sibling
    nil
  end
end
