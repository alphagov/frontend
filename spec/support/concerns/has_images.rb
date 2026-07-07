RSpec.shared_examples "it open can have images" do |document_type, example_name, image_type|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }

  it "can retrieve an image by type" do
    expect(described_class.new(content_store_response).image(image_type)).to be_instance_of(Image)
  end
end
