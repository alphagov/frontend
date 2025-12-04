class Manuals < ContentItem
  include EmphasisedOrganisations
  include ManualSections
  include Manual

  def contributors
    (organisations_ordered_by_emphasis + worldwide_organisations).uniq(&:content_id)
  end
end
