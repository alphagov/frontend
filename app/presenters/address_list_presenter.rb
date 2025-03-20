class AddressListPresenter
  attr_reader :options

  def initialize(addresses)
    @options = addresses.map do |address|
      {
        text: address.address,
        value: LocalAuthority.from_local_custodian_code(address.local_custodian_code).slug,
      }
    end
  end
end
