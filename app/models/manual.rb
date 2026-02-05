class Manual < ContentItem
  include EmphasisedOrganisations
  include ManualLike
  include ManualUpdates
  include Updatable

  def contributors
    organisations_ordered_by_emphasis.uniq(&:content_id)
  end
end
