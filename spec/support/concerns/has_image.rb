RSpec.shared_examples "it can have images" do |document_type, example_name, image_type|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }

  it "can retrieve an image by type" do
    expect(described_class.new(content_store_response).image_for(image_type)).to be_instance_of(Image)
  end

  it "returns nil if asked for a missing type" do
    expect(described_class.new(content_store_response).image_for("bad-type")).to be_nil
  end
end
