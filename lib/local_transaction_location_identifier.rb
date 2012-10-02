class LocalTransactionLocationIdentifier
  def self.find_snac(geostack, artefact)
    return nil unless artefact['details'] and artefact['details']['local_service']

    authorities = geostack['council']
    providing_tier = artefact['details']['local_service']['providing_tier']

    by_tier = Hash[authorities.map {|area| [self.identify_tier(area["type"]), area["ons"]] }]
    providing_tier.map {|tier| by_tier[tier] }.compact.first
  end

  private
    def self.identify_tier(type)
      case type
      when 'DIS' then 'district'
      when 'CTY' then 'county'
      when 'LBO','MTD','UTA' then 'unitary'
      end
    end
end
