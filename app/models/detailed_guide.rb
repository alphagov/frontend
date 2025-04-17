class DetailedGuide < ContentItem
  include EmphasisedOrganisations
  include NationalApplicability
  include Political
  include SinglePageNotificationButton
  include Updatable

  def contributors
    organisations_ordered_by_emphasis.uniq(&:content_id)
  end
end
