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

  def attachments_with_details
    featured_attachments.select { |doc| doc["accessible"] == false && doc["alternative_format_contact_email"] }
  end

  def dataset?
    %w[national_statistics official_statistics transparency].include? document_type
  end

  def featured_attachments
    attachments_from(content_store_response["details"]["featured_attachments"])
  end

  def national_statistics?
    document_type == "national_statistics"
  end
end
