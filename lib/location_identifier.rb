class LocationIdentifier
  private
    def self.authority_types
      ["DIS","LBO","UTA","CTY","LGD","MTD","COI"]
    end

    def self.identify_tier(type)
      case type
      when 'DIS' then 'district'
      when 'CTY' then 'county'
      when 'LBO','MTD','UTA', 'COI' then 'unitary'
      end
    end
end
