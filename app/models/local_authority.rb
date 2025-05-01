class LocalAuthority
  attr_reader :name, :homepage_url, :country_name, :tier, :slug, :gss, :parent

  def self.from_local_custodian_code(local_custodian_code)
    Rails.cache.fetch("LocalAuthority:lcc:#{local_custodian_code}", expires_in: 5.minutes) do
      api_response = Frontend.local_links_manager_api.local_authority_by_custodian_code(local_custodian_code)
      make_from_api_response(api_response)
    end
  end

  def self.from_slug(slug)
    Rails.cache.fetch("LocalAuthority:slug:#{slug}", expires_in: 5.minutes) do
      api_response = Frontend.local_links_manager_api.local_authority(slug)
      make_from_api_response(api_response)
    end
  end

  def initialize(map, parent: nil)
    @name = map["name"]
    @homepage_url = map["homepage_url"]
    @country_name = map["country_name"]
    @tier = map["tier"]
    @slug = map["slug"]
    @gss = map["gss"]
    @parent = parent
  end

  def to_h
    {
      name:,
      homepage_url:,
      tier:,
      slug:,
      parent: parent.to_h,
    }.compact_blank
  end

  private_class_method def self.make_from_api_response(response)
    if response["local_authorities"].count == 2
      parent = LocalAuthority.new(response["local_authorities"].reject { |la| la["tier"] == "district" }.first)
    end
    LocalAuthority.new(response["local_authorities"].reject { |la| la["tier"] == "county" }.first, parent:)
  end
end
