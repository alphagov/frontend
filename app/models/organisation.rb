class Organisation < ContentItem
  def logo
    OpenStruct.new(
      crest: content_store_hash.dig("details", "logo", "crest"),
      formatted_title: content_store_hash.dig("details", "logo", "formatted_title"),
    )
  end
end
