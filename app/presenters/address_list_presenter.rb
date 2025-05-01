class AddressListPresenter
  def initialize(addresses)
    @addresses = addresses
  end

  def options
    @options ||= @addresses.map do |address|
      {
        text: address.address,
        value: LocalAuthority.from_local_custodian_code(address.local_custodian_code).slug,
      }
    end
  end

  def addresses_with_authority_data
    @addresses_with_authority_data ||= @addresses.map do |address|
      local_authority = LocalAuthority.from_local_custodian_code(address.local_custodian_code)
      {
        address: address.address,
        slug: local_authority.slug,
        name: local_authority.name,
      }
    end
  end
end
