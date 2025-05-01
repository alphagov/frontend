require "gds_api/test_helpers/local_links_manager"

RSpec.describe AddressListPresenter do
  include GdsApi::TestHelpers::LocalLinksManager

  subject(:address_list_presenter) { described_class.new(addresses) }

  let(:addresses) do
    [
      OpenStruct.new(address: "HOUSE 1", local_custodian_code: 1),
      OpenStruct.new(address: "HOUSE 2", local_custodian_code: 2),
    ]
  end

  before do
    stub_local_links_manager_has_a_local_authority("achester", local_custodian_code: 1)
    stub_local_links_manager_has_a_local_authority("beechester", local_custodian_code: 2)
  end

  describe "#component_options" do
    it "returns a list of addresses and slugs suitable for passing to a component" do
      expect(address_list_presenter.component_options).to eq([
        { text: "HOUSE 1", value: "achester" },
        { text: "HOUSE 2", value: "beechester" },
      ])
    end
  end

  describe "#addresses_with_authority_data" do
    it "returns a list of addresses, slugs, and authority names suitable for passing to the api" do
      expect(address_list_presenter.addresses_with_authority_data).to eq([
        { address: "HOUSE 1", local_authority_slug: "achester", local_authority_name: "Achester" },
        { address: "HOUSE 2", local_authority_slug: "beechester", local_authority_name: "Beechester" },
      ])
    end
  end
end
