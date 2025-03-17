class LocalAuthority
  attr_reader :name, :homepage_url, :country_name, :tier, :slug, :gss, :parent

  def self.from_local_custodian_code(local_custodian_code)
    Rails.cache.fetch(local_custodian_code, expires_in: 5.minutes) do
      authority_results = Frontend.local_links_manager_api.local_authority_by_custodian_code(local_custodian_code)
      if authority_results["local_authorities"].count == 2
        parent = LocalAuthority.new(authority_results["local_authorities"].last)
      end
      LocalAuthority.new(authority_results["local_authorities"].first, parent:)
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
end
