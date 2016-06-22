class AuthorityLookup
  cattr_accessor :authorities

  def self.find_slug_from_snac(snac)
    area = Frontend.mapit_api.area_for_code("ons", snac)
    area['codes']['govuk_slug'] if area
  end

  def self.find_snac_from_slug(slug)
    area = Frontend.mapit_api.area_for_code("govuk_slug", slug)
    area['codes']['ons'] if area
  end
end
