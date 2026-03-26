RSpec.describe EmphasisedOrganisations do
  include described_class

  let(:organisations) do
    [
      Organisation.new("content_id" => "0", "title" => "Department of Zoology", "details" => { "logo" => {} }),
      Organisation.new("content_id" => "1", "title" => "Department of Decentralisation", "details" => { "logo" => {} }),
      Organisation.new("content_id" => "2", "title" => "Department of Biology", "details" => { "logo" => {} }),
      Organisation.new("content_id" => "3", "title" => "Department of Alphabetization", "details" => { "logo" => {} }),
    ]
  end
  let(:content_store_response) { {} }

  describe "#organisations_ordered_by_emphasis" do
    it "shows organisations in alphabetical order" do
      expect(organisations_ordered_by_emphasis.collect(&:content_id)).to eq(%w[3 2 1 0])
    end

    context "when emphasised organisations are present" do
      let(:content_store_response) { { "details" => { "emphasised_organisations" => %w[1 2] } } }

      it "shows the emphasised organisations in their fixed order first, then others in alphabetical order" do
        expect(organisations_ordered_by_emphasis.collect(&:content_id)).to eq(%w[1 2 3 0])
      end
    end
  end
end
