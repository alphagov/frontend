class LicenceDetailsPresenter
  include Rails.application.routes.url_helpers

  attr_reader :licence, :authority_slug, :interaction

  def initialize(licence, authority_slug = nil, interaction = nil)
    @licence = licence
    @authority_slug = authority_slug
    @interaction = interaction
  end

  delegate :present?, to: :licence

  def local_authority_specific?
    licence_details["location_specific"]
  end

  def licence_authority_specific?
    !licence_details["location_specific"]
  end

  def has_any_actions?
    authority && authority["actions"].present?
  end

  def actions_for_contents_list_component(publication)
    items = [
      {
        text: "1. Overview",
        href: !action ? nil : licence_transaction_authority_path(publication.slug, authority_slug, interaction: nil),
        active: !action,
      },
    ]

    authority["actions"].keys.each_with_index do |action_key, index|
      items << {
        text: "#{index + 2}. How to #{action_key}",
        href: action == action_key ? nil : licence_transaction_authority_interaction_path(publication.slug, authority_slug, action_key),
        active: action == action_key,
      }
    end

    items
  end

  def uses_licensify(chosen_action = action)
    return false unless authority

    chosen_action_info = authority.dig("actions", chosen_action)
    if chosen_action_info.present?
      chosen_action_info.any? { |link| link && link["uses_licensify"] }
    else
      false
    end
  end

  def uses_authority_url(chosen_action = action)
    return false unless authority

    chosen_action_info = authority.dig("actions", chosen_action)
    if chosen_action_info.present?
      chosen_action_info.any? { |link| link && link["uses_authority_url"] }
    else
      false
    end
  end

  def action
    return nil unless interaction
    raise RecordNotFound unless authority["actions"].key?(interaction)

    interaction
  end

  def offered_by_county?
    licence_details["is_offered_by_county"]
  end

  def single_licence_authority_present?
    licence_authority_specific? && authority
  end

  def authority
    if authority_slug
      authorities_from_api_response.find { |a| a["slug"] == authority_slug }
    else
      authorities_from_api_response.first
    end
  end

private

  def licence_details
    return {} unless licence

    {
      "location_specific" => licence["isLocationSpecific"],
      "is_offered_by_county" => licence["isOfferedByCounty"],
      "availability" => licence["geographicalAvailability"],
      "authorities" => authorities_from_api_response,
    }
  end

  def authorities_from_api_response
    if licence && licence["issuingAuthorities"]
      licence["issuingAuthorities"].map do |authority|
        {
          "name" => authority["authorityName"],
          "slug" => authority["authoritySlug"],
          "contact" => authority["authorityContact"],
          "actions" => authority["authorityInteractions"].transform_values do |links|
            links.map do |link|
              {
                "url" => link["url"],
                "introduction" => link["introductionText"],
                "description" => link["description"],
                "payment" => link["payment"],
                "uses_authority_url" => (link["usesAuthorityUrl"] == true),
                "uses_licensify" => (link["usesLicensify"] == true),
              }
            end
          end,
        }
      end
    else
      []
    end
  end
end
