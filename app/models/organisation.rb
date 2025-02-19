class Organisation < ContentItem
  def logo
    OpenStruct.new(formatted_title: content_store_hash.dig("details", "logo", "formatted_title"))
  end
end
