class WorldwideCorporateInformationPage < ContentItem
  def worldwide_organisation
    linked("worldwide_organisation").first
  end
end
