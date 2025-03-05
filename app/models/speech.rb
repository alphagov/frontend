class Speech < ContentItem
  include EmphasisedOrganisations
  include NewsImage
  include People
  include Political
  include Updatable

  def contributors
    (organisations_ordered_by_emphasis + people + speaker).compact.uniq(&:content_id)
  end

  def speaker
    linked("speaker")
  end

  def speaker_without_profile
    content_store_response.dig("details", "speaker_without_profile")
  end

  def location
    content_store_response.dig("details", "location")
  end

  def delivered_on_date
    content_store_response.dig("details", "delivered_on")
  end

  def speech_type_explanation
    explanation = content_store_response.dig("details", "speech_type_explanation")
    " (#{explanation})" if explanation
  end
end
