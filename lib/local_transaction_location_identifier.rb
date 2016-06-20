require 'location_identifier'

class LocalTransactionLocationIdentifier < LocationIdentifier
  def self.find_slug(areas, artefact)
    new(areas, artefact).find_slug
  end

  attr_reader :areas, :artefact

  def initialize(areas, artefact)
    @areas = areas
    @artefact = artefact
  end

  def find_slug
    matching_authority_by_tier_slug
  end

private

  def matching_authority_by_tier_slug
    matching_authority_by_tier.try(:[], "codes").try(:[], "govuk_slug")
  end

  def matching_authority_by_tier
    service_providing_tiers.each do |tier|
      areas.each do |area|
        return area if tier == LocationIdentifier.identify_tier(area["type"])
      end
    end
    nil
  end

  def service_providing_tiers
    return unless artefact

    artefact["details"].try(:[], "local_service").try(:[], "providing_tier")
  end
end
