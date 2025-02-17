class Speech < ContentItem  
  include Organisations  
  include Updatable

  def contributors
    (organisations + [speaker].flatten + [speaker_without_profile].flatten).compact
  end

  def speaker
    content_store_hash.dig("links", "speaker")
  end

  def speaker_without_profile
    content_store_hash.dig("details", "speaker_without_profile")
  end

  def location
    content_store_hash.dig("details", "location")
  end

  def delivered_on_date
    content_store_hash.dig("details", "delivered_on")
  end

  def speech_type_explanation
    explanation = content_store_hash.dig("details", "speech_type_explanation")
    " (#{explanation})" if explanation
  end
end
