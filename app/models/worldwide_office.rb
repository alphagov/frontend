class WorldwideOffice < ContentItem
  def worldwide_organisation
    linked("parent").first
  end

  def contact
    linked("contact")
  end
end
