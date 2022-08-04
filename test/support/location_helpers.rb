require "gds_api/test_helpers/locations_api"
require "gds_api/test_helpers/local_links_manager"

module LocationHelpers
  include GdsApi::TestHelpers::LocationsApi
  include GdsApi::TestHelpers::LocalLinksManager

  def configure_locations_api_and_local_authority(postcode, authorities, local_custodian_code, snac: "00BK")
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
      stub_local_links_manager_has_a_local_authority(authority, local_custodian_code: local_custodian_code, snac: snac)
    end
  end
end
