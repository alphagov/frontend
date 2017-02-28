class LicenceDetailsPresenter
  attr_reader :licence

  def initialize(licence)
    @licence = licence
  end

  def present
    return {} unless licence

    if licence["error"]
      return { "error" => licence["error"] }
    end

    {
      "location_specific" => licence["isLocationSpecific"],
      "availability" => licence["geographicalAvailability"],
      "is_offered_by_county" => licence["isOfferedByCounty"],
      "authorities" => authorities,
    }
  end

private

  def authorities
    if licence['issuingAuthorities']
      licence['issuingAuthorities'].map {|authority|
        {
          'name' => authority['authorityName'],
          'slug' => authority['authoritySlug'],
          'contact' => authority['authorityContact'],
          'actions' => authority['authorityInteractions'].inject({}) {|actions, (key, links)|
            actions[key] = links.map {|link|
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
