RSpec.shared_examples "it can present service navigation items" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }
  let(:ordered_items) { content_store_response["details"]["ordered_navigation_items"] }

  it "returns the items formatted for the service navigation component, prepended with the root item" do
    expect(described_class.new(content_item).ordered_navigation_items_for_service_navigation.count).to eq(ordered_items.count + 1)
    expect(described_class.new(content_item).ordered_navigation_items_for_service_navigation.first.keys).to eq(%i[active href text])
  end

  it "appends `home` to the root item's text" do
    expect(described_class.new(content_item).ordered_navigation_items_for_service_navigation.first[:text]).to eq("#{content_item.title} home")
  end
end
