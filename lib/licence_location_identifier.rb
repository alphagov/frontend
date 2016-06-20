require 'location_identifier'

class LicenceLocationIdentifier < LocationIdentifier
  # If the licence has an equivalent local service in the LGSL, try
  # to find the most appropriate council from the "providing tier"
  # if not, then return the closest authority available.
  def self.find_slug(areas, artefact)
    new(areas, artefact).find_slug
  end

  attr_reader :areas, :artefact

  def initialize(areas, artefact)
    @areas = areas
    @artefact = artefact
  end

  def find_slug
    matching_authority_by_tier_slug || matching_authority_by_area_type_slug
  end

private

  def matching_authority_by_tier_slug
    matching_authority_by_tier.try(:[], "codes").try(:[], "govuk_slug")
  end

  def matching_authority_by_tier
    return nil unless service_providing_tiers

    service_providing_tiers.each do |tier|
      areas.each do |area|
        return area if tier == LocationIdentifier.identify_tier(area["type"])
      end
    end
    nil
  end

  def service_providing_tiers
    return unless artefact

    artefact["details"].try(:[], "licence").try(:[], "local_service").try(:[], "providing_tier")
  end

  def matching_authority_by_area_type_slug
    matching_authority_by_area_type.try(:[], "codes").try(:[], "govuk_slug")
  end

  def matching_authority_by_area_type
    LocationIdentifier.authority_types.each do |type|
      areas.each do |area|
        return area if area["type"] == type && area_has_slug?(area)
      end
    end
    nil
  end

  def area_has_slug?(area)
    !!area.try(:[], "codes").try(:[], "govuk_slug")
  end
end
