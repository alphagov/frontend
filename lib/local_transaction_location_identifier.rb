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
    if providing_tier && matching_authority_by_tier
      matching_authority_by_tier[:govuk_slug]
    end
  end

private

  def providing_tier
    return unless artefact

    artefact["details"].try(:[], "local_service").try(:[], "providing_tier")
  end

  def matching_authority_by_tier
    @_authority_by_tier ||= areas.detect do |area|
      providing_tier.include?(LocationIdentifier.identify_tier(area[:type]))
    end
  end
end
