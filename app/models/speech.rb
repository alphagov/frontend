class Speech < ContentItem  
  include Organisations
  include Political
  include Updatable
  include NewsImage  

  def related_entities
    linkable_organisations + speaker
  end

  def speaker
    content_store_hash.dig("links", "speaker")
  end

end
