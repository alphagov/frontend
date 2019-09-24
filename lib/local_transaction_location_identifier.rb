class LocalTransactionLocationIdentifier
  def self.find_slug(areas, content_item, tier_override = nil)
    new(areas, content_item, tier_override).find_slug
  end

  def self.find_country(areas, content_item, tier_override = nil)
    new(areas, content_item, tier_override).find_country
  end

  attr_reader :areas, :content_item, :tier_override

  def initialize(areas, content_item, tier_override = nil)
    @areas = areas
    @content_item = content_item
    @tier_override = tier_override
  end

  def find_slug
    matching_authority_by_tier_slug
  end

  def find_country
    matching_country_by_tier_slug
  end

private

  def matching_authority_by_tier_slug
    matching_authority_by_tier.try(:[], "codes").try(:[], "govuk_slug")
  end

  def matching_country_by_tier_slug
    matching_authority_by_tier.try(:[], "country_name")
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

  def identify_tier(type)
    case type
    when "DIS" then "district"
    when "CTY" then "county"
    when "LBO", "LGD", "MTD", "UTA", "COI" then "unitary"
    end
  end

  def service_providing_tiers
    return unless content_item

    content_item["details"].try(:[], "service_tiers")
  end
end
