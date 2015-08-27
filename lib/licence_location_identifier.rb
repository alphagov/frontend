require 'location_identifier'

class LicenceLocationIdentifier < LocationIdentifier
  # If the licence has an equivalent local service in the LGSL, try
  # to find the most appropriate council from the "providing tier"
  # if not, then return the closest authority available.
  def self.find_snac(geostack, artefact = nil)
    councils = geostack["council"].map do |area|
      [area["type"], area["ons"]]
    end

    if artefact and providing_tier = artefact["details"].try(:[], "licence").try(:[], "local_service").try(:[], "providing_tier")
      councils_by_tier = Hash[councils.collect do |k, v|
        [self.identify_tier(k), v]
      end]

      appropriate_authority = providing_tier.map do |tier|
        councils_by_tier[tier]
      end.compact.first

      return appropriate_authority unless appropriate_authority.nil?
    end

    authorities = Hash[councils]
    self.authority_types.each do |type|
      return authorities[type] unless authorities[type].nil?
    end

    nil
  end
end
