# This is to support the rare but possible case where a 2-tier hierarchy has a district
# and a unitary (rather than district and council), which can happen during merge periods
# where it is useful for a short period of time to mark a county as a unitary if it is
# becoming one. If we reengineer LLM we can probably remove this, but for now it simplifies
# the merges and prevents the site breaking during the merge period.
# See find_local_council_controller#result for more explanation

LOCAL_LINKS_MANAGER_ENDPOINT = Plek.find("local-links-manager")

def stub_local_links_manager_has_a_district_and_unitary_local_authority(district_slug, unitary_slug, district_snac: "00AG", unitary_snac: "00LC", local_custodian_code: nil)
  response = {
    "local_authorities" => [
      {
        "name" => district_slug.capitalize,
        "homepage_url" => "http://#{district_slug}.example.com",
        "country_name" => "England",
        "tier" => "district",
        "slug" => district_slug,
        "snac" => district_snac,
      },
      {
        "name" => unitary_slug.capitalize,
        "homepage_url" => "http://#{unitary_slug}.example.com",
        "country_name" => "England",
        "tier" => "unitary",
        "slug" => unitary_slug,
        "snac" => unitary_snac,
      },
    ],
  }

  stub_request(:get, "#{LOCAL_LINKS_MANAGER_ENDPOINT}/api/local-authority")
    .with(query: { authority_slug: district_slug })
    .to_return(body: response.to_json, status: 200)

  unless local_custodian_code.nil?
    stub_request(:get, "#{LOCAL_LINKS_MANAGER_ENDPOINT}/api/local-authority")
      .with(query: { local_custodian_code: })
      .to_return(body: response.to_json, status: 200)
  end
end
