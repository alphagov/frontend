class DetailedGuide < ContentItem
  include EmphasisedOrganisations
  include NationalApplicability
  include Political
  include SinglePageNotificationButton
  include Updatable

  attr_reader :headers

  def initialize(content_store_response)
    super(content_store_response)

    @headers = content_store_response.dig("details", "headers") || []
  end

  def contributors
    organisations_ordered_by_emphasis.uniq(&:content_id)
  end
end
