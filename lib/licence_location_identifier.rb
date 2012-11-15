require_relative 'location_identifier'

class LicenceLocationIdentifier < LocationIdentifier
  def self.find_snac(geostack, artefact = nil)

    # if the licence has an equivalent local service in the LGSL, try to find
    # the most appropriate council from the "providing tier"
    # if not, then return the closest authority available

    if artefact and artefact['details']['licence'] and artefact['details']['licence']['local_service'] and artefact['details']['licence']['local_service']['providing_tier']
      providing_tier = artefact['details']['licence']['local_service']['providing_tier']

      authorities = geostack['council']
      by_tier = Hash[authorities.map {|area| [self.identify_tier(area["type"]), area["ons"]] }]

      appropriate_authority = providing_tier.map {|tier| by_tier[tier] }.compact.first
      return appropriate_authority unless appropriate_authority.nil?
    end

    authorities = Hash[geostack['council'].map {|area| [area['type'], area['ons']] }]
    self.authority_types.each {|type|
      return authorities[type] unless authorities[type].nil?
    }
    return nil
  end
end
