class LicenceLocationIdentifier
  def self.find_snac(geostack, artefact = nil)
    authorities = Hash[geostack['areas'].map {|i,area| [area['type'], area['codes']['ons']] }]
    self.authority_types.each {|type|
      return authorities[type] unless authorities[type].nil?
    }
    return nil
  end

  def self.authority_types
    ["DIS","LBO","UTA","CTY","LGD"]
  end
end
