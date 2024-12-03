RSpec.shared_examples "it is a landing-page block" do
  let(:block_name) { described_class.name.split("::").last.underscore }

  # Relies on the convention that all Level 4 headings in the documentation are block names
  it "has a heading in the block documentation" do
    documentation = File.read(Rails.root.join("docs/building_blocks_for_flexible_content.md"))

    expect(/^#### #{block_name.titleize}\n$/.match(documentation)).not_to be_nil
  end

  it "has a correctly named partial" do
    expect(File).to exist(Rails.root.join("app/views/landing_page/blocks/_#{block_name}.html.erb"))
  end

  it "derives from LandingPage::Block::Base" do
    expect(described_class.ancestors).to include(LandingPage::Block::Base)
  end
end
