class LocalAuthoritySlugFinder
  AUTHORITY_TYPES = %w[DIS LBO UTA CTY LGD MTD COI].freeze
  COUNTY_LOCAL_AUTHORITY_TYPE = "CTY".freeze

  def self.call(areas, county_requested: false)
    new(areas, county_requested).find_slug
  end

  def initialize(areas, county_requested)
    @areas = areas
    @county_requested = county_requested
  end

  def find_slug
    if county_requested && county_local_authority_with_slug
      county_local_authority_with_slug["codes"]["govuk_slug"]
    else
      matching_authority_by_area_type_slug
    end
  end

private

  attr_reader :areas, :county_requested

  def county_local_authority_with_slug
    areas.detect { |a| a["type"] == COUNTY_LOCAL_AUTHORITY_TYPE && area_has_slug?(a) }
  end

  def matching_authority_by_area_type_slug
    AUTHORITY_TYPES.each do |type|
      areas.each do |area|
        return area["codes"]["govuk_slug"] if area["type"] == type && area_has_slug?(area)
      end
    end
    nil
  end

  def area_has_slug?(area)
    area.try(:[], "codes").try(:[], "govuk_slug").present?
  end
end
