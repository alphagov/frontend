RSpec.describe LandingPage::Block::BlockError do
  subject(:block_error) { described_class.new(blocks_hash, build(:landing_page)) }

  let(:blocks_hash) do
    {
      "type" => "block_error",
      "error" => StandardError.new("This error"),
    }
  end

  it_behaves_like "it is a landing-page block"

  it "has an error" do
    expect(block_error.error).to be_instance_of(StandardError)
    expect(block_error.error.message).to eq("This error")
  end
end
