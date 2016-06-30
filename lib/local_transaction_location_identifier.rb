require 'location_identifier'

class LocalTransactionLocationIdentifier < LocationIdentifier
  def find_slug
    matching_authority_by_tier_slug
  end

private

  def service_providing_tiers
    return unless artefact

    artefact["details"].try(:[], "local_service").try(:[], "providing_tier")
  end
end
