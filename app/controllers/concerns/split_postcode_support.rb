# Assumes it's being included in a controller with a postcode
# method - is there a better way to support this?
module SplitPostcodeSupport
  def address_list
    @address_list ||= build_addresses(postcode)
  end

  def options
    items = []
    address_list.each do |address_result|
      address = {}
      address[:text] = address_result["address"]
      address[:value] = address_result["authority_slug"]
      items.push(address)
    end
    items
  end

  def build_addresses(postcode)
    base_addresses = fetch_addresses(postcode)
    base_addresses.each do |ba|
      ba["authority_slug"] = authority_slug_from_lcc(ba["local_custodian_code"])
    end
  end

  def authority_slug_from_lcc(local_custodian_code)
    authority_results = Frontend.local_links_manager_api.local_authority_by_custodian_code(local_custodian_code)
    authority_results["local_authorities"][0]["slug"]
  end

  def fetch_addresses(postcode)
    # We only do this after fetching location, so relatively safe to miss out
    # some of the safeguards. But we can optimize this a bit
    response = Frontend.locations_api.results_for_postcode(postcode)
    response["results"]
  end
end
