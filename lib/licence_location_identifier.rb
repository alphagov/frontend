require 'location_identifier'

class LicenceLocationIdentifier < LocationIdentifier
  # If the licence has an equivalent local service in the LGSL, try
  # to find the most appropriate council from the "providing tier"
  # if not, then return the closest authority available.
  def self.find_slug(areas, artefact = nil)
    new(areas, artefact).find_slug
  end

  attr_reader :areas, :artefact

  def initialize(areas, artefact)
    @areas = areas
    @artefact = artefact
  end

  def find_slug
    if providing_tier && matching_authority_by_tier
      matching_authority_by_tier[:govuk_slug]
    elsif matching_authority_by_area_type
      matching_authority_by_area_type[:govuk_slug]
    end
  end

private

  def providing_tier
    return unless artefact

    artefact["details"].try(:[], "licence").try(:[], "local_service").try(:[], "providing_tier")
  end

  def matching_authority_by_tier
    @_authority_by_tier ||= areas.detect do |area|
      providing_tier.include?(LocationIdentifier.identify_tier(area[:type]))
    end
  end

  def matching_authority_by_area_type
    @_authority_by_type ||= LocationIdentifier.authority_types.each do |type|
      areas.each do |area|
        return area if area[:type] == type
      end
    end
    nil
  end
end
