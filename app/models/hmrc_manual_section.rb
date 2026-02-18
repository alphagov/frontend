class HmrcManualSection < ContentItem
  include ManualLike

  attr_reader :child_section_groups, :section_id

  def initialize(content_store_response)
    super

    @child_section_groups = details["child_section_groups"]
    @section_id = details["section_id"]
  end

  def next_sibling
    adjacent_siblings.last
  end

  def previous_sibling
    adjacent_siblings.first
  end

private

  def siblings
    return [] unless parent_for_section

    sibling_child_sections = parent_for_section.details["child_section_groups"].map do |group|
      included_section = group["child_sections"].find { |section| section["section_id"].include?(section_id) }
      group["child_sections"] if included_section.present?
    end

    sibling_child_sections.compact.flatten
  end

  def adjacent_siblings
    before, after = siblings.split do |section|
      section["section_id"] == section_id
    end

    [before.try(:last), after.try(:first)]
  end

  def parent_for_section
    return manual_content_item unless details["breadcrumbs"].any?

    @parent_for_section ||= load_section_parent
  end

  def load_section_parent
    base_path = details["breadcrumbs"].last["base_path"]
    response = ContentItemLoaders::ContentStoreLoader.new.load(base_path:)
    ContentItemFactory.build(response)
  end
end
