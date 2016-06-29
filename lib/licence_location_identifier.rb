require 'location_identifier'

class LicenceLocationIdentifier < LocationIdentifier
  # If the licence has an equivalent local service in the LGSL, try
  # to find the most appropriate council from the "providing tier"
  # if not, then return the closest authority available.
  def find_slug
    matching_authority_by_tier_slug || matching_authority_by_area_type_slug
  end

private

  def service_providing_tiers
    return unless artefact

    artefact["details"].try(:[], "licence").try(:[], "local_service").try(:[], "providing_tier")
  end

  def matching_authority_by_area_type_slug
    matching_authority_by_area_type.try(:[], "codes").try(:[], "govuk_slug")
  end

  def matching_authority_by_area_type
    authority_types.each do |type|
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
