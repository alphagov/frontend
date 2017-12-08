class LicenceDetailsPresenter
  attr_reader :licence, :authority_slug, :interaction

  def initialize(licence, authority_slug = nil, interaction = nil)
    @licence = licence
    @authority_slug = authority_slug
    @interaction = interaction
  end

  def present?
    licence.present?
  end

  def local_authority_specific?
    licence_details["location_specific"]
  end

  def licence_authority_specific?
    !licence_details["location_specific"]
  end

  def action
    return nil unless interaction
    raise RecordNotFound unless authority["actions"].keys.include?(interaction)

    interaction
  end

  def offered_by_county?
    licence_details["is_offered_by_county"]
  end

  def single_licence_authority_present?
    licence_authority_specific? && authority
  end

  def multiple_licence_authorities_present?
    licence_authority_specific? && authorities.size > 1
  end

  def authorities
    authorities_from_api_response
  end

  def authority
    if authorities.size == 1
      authorities_from_api_response.first
    elsif authorities.size > 1 && local_authority_specific?
      authorities_from_api_response.first
    elsif authorities.size > 1 && authority_slug
      authorities.detect { |a| a["slug"] == authority_slug }
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
    if licence && licence['issuingAuthorities']
      licence['issuingAuthorities'].map { |authority|
        {
          'name' => authority['authorityName'],
          'slug' => authority['authoritySlug'],
          'contact' => authority['authorityContact'],
          'actions' => authority['authorityInteractions'].inject({}) { |actions, (key, links)|
            actions[key] = links.map { |link|
              {
                'url' => link['url'],
                'introduction' => link['introductionText'],
                'description' => link['description'],
                'payment' => link['payment']
              }
            }
            actions
          }
        }
      }
    else
      []
    end
  end
end
