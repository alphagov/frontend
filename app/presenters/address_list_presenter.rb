class AddressListPresenter
  def initialize(addresses)
    @addresses = addresses
  end

  def component_options
    addresses_with_authority_data.map { |address| { text: address[:address], value: address[:local_authority_slug] } }
  end

  def addresses_with_authority_data
    @addresses_with_authority_data ||= @addresses.map do |address|
      log_7655_presence(address.address) if address.local_custodian_code == 7655

      local_authority = LocalAuthority.from_local_custodian_code(address.local_custodian_code)
      {
        address: address.address,
        local_authority_slug: local_authority.slug,
        local_authority_name: local_authority.name,
      }
    end
  end

  def log_7655_presence(address)
    GovukError.notify(
      "Address results included Ordnance Survey Local Custodian Code (7655)",
      extra: {
        address: address,
      },
      level: "warning",
    )
  end
end
