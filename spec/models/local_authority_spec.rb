RSpec.describe LocalAuthority do
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
end
