class Publication < ContentItem
  include Attachments
  include EmphasisedOrganisations
  include NationalApplicability
  include People
  include Political
  include SinglePageNotificationButton
  include Updatable

  def contributors
    (organisations_ordered_by_emphasis + people).uniq
  end

  def all_inaccessible_attachments_with_email
    inaccessible_attachments_with_email(featured_attachments)
  end

  def dataset?
    %w[national_statistics official_statistics transparency].include? document_type
  end

  def national_statistics?
    document_type == "national_statistics"
  end
end
