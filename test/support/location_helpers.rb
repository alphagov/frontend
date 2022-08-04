require "gds_api/test_helpers/mapit"
require "gds_api/test_helpers/local_links_manager"

module LocationHelpers
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::LocalLinksManager

  def configure_mapit_and_local_links(postcode: "SW1A 1AA", authority: "westminster", lgsl: 461, lgil: 8)
    stub_mapit_has_a_postcode_and_areas(
      postcode,
      [51.5010096, -0.1415870],
      [
        { "ons" => "00BK", "name" => "Westminster City Council", "type" => "LBO", "govuk_slug" => authority },
        { "name" => "Greater London Authority", "type" => "GLA" },
      ],
    )

    westminster = {
      "id" => 2432,
      "codes" => {
        "ons" => "00BK",
        "gss" => "E07000198",
        "govuk_slug" => authority,
      },
      "name" => authority.titleize,
    }

    stub_mapit_has_area_for_code("govuk_slug", authority, westminster)

    stub_local_links_manager_has_a_link(
      authority_slug: authority,
      lgsl: lgsl,
      lgil: lgil,
      url: "http://www.westminster.gov.uk/bear-the-cost-of-grizzly-ownership-2016-update",
      country_name: "England",
      status: "ok",
    )
  end
end
