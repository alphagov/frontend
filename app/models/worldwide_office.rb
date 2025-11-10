class WorldwideOffice < ContentItem
  def worldwide_organisation
    linked("worldwide_organisation").first
  end

  def contact
    linked("contact")
  end
end
