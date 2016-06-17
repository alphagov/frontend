class LocationIdentifier
  private
    DISTRICT = ['DIS']
    COUNTY = ['CTY']
    UNITARY = %w(COI LBO LGD MTD UTA)

    #It is important that DIS (district) is before CTY (county) in the list of
    # authority types as licences want the most specific provider first. All
    # the others are unitary so we can order them in a manner which suits us.
    def self.authority_types
      DISTRICT + COUNTY + UNITARY
    end

    def self.identify_tier(type)
      case type
      when *DISTRICT then 'district'
      when *COUNTY then 'county'
      when *UNITARY then 'unitary'
      end
    end
end
