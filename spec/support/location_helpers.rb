require "gds_api/test_helpers/locations_api"
require "gds_api/test_helpers/local_links_manager"

module LocationHelpers
  include GdsApi::TestHelpers::LocationsApi
  include GdsApi::TestHelpers::LocalLinksManager

  def configure_locations_api_and_local_authority(postcode, authorities, local_custodian_code, snac: "00BK", gss: "E06000064")
    stub_locations_api_has_location(
      postcode,
      [
        {
          "latitude" => 51.5010096,
          "longitude" => -0.1415870,
          "local_custodian_code" => local_custodian_code,
        },
      ],
    )
    authorities.each do |authority|
      stub_local_links_manager_has_a_local_authority(authority, local_custodian_code:, snac:, gss:)
    end
  end

  def stub_local_links_manager_has_a_county(authority_slug)
    response = {
      "local_authorities" => [
        {
          "name" => authority_slug.capitalize,
          "homepage_url" => "",
          "country_name" => "England",
          "tier" => "county",
          "slug" => authority_slug,
          "gss" => "E0000001",
        },
      ],
    }

    stub_request(:get, "#{GdsApi::TestHelpers::LocalLinksManager::LOCAL_LINKS_MANAGER_ENDPOINT}/api/local-authority")
      .with(query: { authority_slug: })
      .to_return(body: response.to_json, status: 200)
  end
end
