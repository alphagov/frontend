class LocationIdentifier
  def self.find_slug(areas, artefact)
    new(areas, artefact).find_slug
  end

  attr_reader :areas, :artefact

  def initialize(areas, artefact)
    @areas = areas
    @artefact = artefact
  end

private

  def matching_authority_by_tier_slug
    matching_authority_by_tier.try(:[], "codes").try(:[], "govuk_slug")
  end

  def matching_authority_by_tier
    return nil unless service_providing_tiers

    service_providing_tiers.each do |tier|
      areas.each do |area|
        return area if tier == identify_tier(area["type"])
      end
    end
    nil
  end

  def authority_types
    %w(DIS LBO UTA CTY LGD MTD COI)
  end

  def identify_tier(type)
    case type
    when 'DIS' then 'district'
    when 'CTY' then 'county'
    when 'LBO', 'MTD', 'UTA', 'COI' then 'unitary'
    end
  end
end
