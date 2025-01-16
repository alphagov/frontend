class Speech < ContentItem
  include NewsImage
  include Organisations
  include Political
  include Updatable

  def contributors
    organisations + (speaker || []) + (speaker_without_profile ? [speaker_without_profile] : [])
  end

  def speaker
    content_store_hash.dig("links", "speaker")
  end

  def speaker_without_profile
    content_store_hash.dig("details", "speaker_without_profile")
  end
end
