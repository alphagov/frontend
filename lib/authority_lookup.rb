class AuthorityLookup
  attr_reader :snac, :slug
  LOCAL_AUTHORITY_TYPES = %w{ CTY DIS LBO LGD MTD UTA COI }

  def self.find_snac_from_slug(slug)
    new(slug: slug).find_snac_from_slug
  end

  def initialize(params)
    @snac = params[:snac]
    @slug = params[:slug]
  end

  def find_snac_from_slug
    authority_by_slug.map { |_, v| v["codes"]["ons"] }.first
  end

  def self.local_authority_types
    LOCAL_AUTHORITY_TYPES.join(",")
  end

private

  def authority_by_slug
    # fairly expensive call at the moment. Could this be a supported mapit route?
    authorities.to_h.select { |_, v| v["codes"]["govuk_slug"] == slug }
  end

  def authorities
    @_authorities ||= Frontend.mapit_api.areas_for_type(LOCAL_AUTHORITY_TYPES.join(","))
  end
end
