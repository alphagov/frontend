class Speech < ContentItem
  include Organisations
  include Political
  include Updatable
  include NewsImage

  def related_entities
    entities = linkable_organisations + (speaker || [])
    entities += [speaker_without_profile] if speaker_without_profile
    entities.uniq
  end

  def speaker
    content_store_hash.dig("links", "speaker")
  end

  def speaker_without_profile
    content_store_hash.dig("details", "speaker_without_profile")
  end
end
