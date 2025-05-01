class AddressListPresenter
  def initialize(addresses)
    @addresses = addresses
  end

  def component_options
    addresses_with_authority_data.map { |address| { text: address[:address], value: address[:local_authority_slug] } }
  end

  def addresses_with_authority_data
    @addresses_with_authority_data ||= @addresses.map do |address|
      local_authority = LocalAuthority.from_local_custodian_code(address.local_custodian_code)
      {
        address: address.address,
        local_authority_slug: local_authority.slug,
        local_authority_name: local_authority.name,
      }
    end
  end
end
