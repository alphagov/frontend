RSpec.describe LocalAuthority do
  include LocationHelpers

  subject(:local_authority) { described_class.new(local_authority_hash, parent:) }

  let(:local_authority_hash) do
    {
      "name" => "Westminster",
      "homepage_url" => "http://westminster.example.com",
      "country_name" => "england",
      "tier" => "unitary",
      "slug" => "westminster",
      "gss" => "E09000033",
    }
  end

  let(:parent) { nil }

  describe "#to_h" do
    it "returns the local authority" do
      expect(local_authority.to_h).to eq({
        name: "Westminster",
        homepage_url: "http://westminster.example.com",
        tier: "unitary",
        slug: "westminster",
      })
    end

    context "with the district slug of a two-tier authority" do
      let(:local_authority_hash) do
        {
          "name" => "Lichfield District Council",
          "homepage_url" => "http://lichfield.example.com",
          "country_name" => "england",
          "tier" => "district",
          "slug" => "lichfield",
          "gss" => "E07000194",
        }
      end

      let(:local_authority_parent_hash) do
        {
          "name" => "Staffordshire County Council",
          "homepage_url" => "http://staffordshire.example.com",
          "country_name" => "england",
          "tier" => "county",
          "slug" => "staffordshire",
          "gss" => "E10000028",
        }
      end

      let(:parent) { described_class.new(local_authority_parent_hash, parent: nil) }

      it "returns the county nested in the district" do
        expect(local_authority.to_h).to eq({
          name: "Lichfield District Council",
          homepage_url: "http://lichfield.example.com",
          tier: "district",
          slug: "lichfield",
          parent: {
            name: "Staffordshire County Council",
            homepage_url: "http://staffordshire.example.com",
            tier: "county",
            slug: "staffordshire",
          },
        })
      end
    end
  end

  describe ".from_slug" do
    before do
      stub_local_links_manager_has_a_local_authority("westminster")
    end

    it "returns a local authority model" do
      expect(described_class.from_slug("westminster")).to be_instance_of(described_class)
      expect(described_class.from_slug("westminster").name).to eq("Westminster")
    end

    context "when the slug describes the district of a two-tier body" do
      before do
        stub_local_links_manager_has_a_district_and_county_local_authority("staffordshire-moorlands", "staffordshire")
      end

      it "returns a local authority model" do
        expect(described_class.from_slug("staffordshire-moorlands")).to be_instance_of(described_class)
        expect(described_class.from_slug("staffordshire-moorlands").name).to eq("Staffordshire-moorlands")
      end
    end

    context "when the slug describes only the county of a two-tier body" do
      before do
        stub_local_links_manager_has_a_county("shropshire")
      end

      it "returns a local authority model" do
        expect(described_class.from_slug("shropshire")).to be_instance_of(described_class)
        expect(described_class.from_slug("shropshire").name).to eq("Shropshire")
      end
    end
  end
end
