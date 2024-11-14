RSpec.shared_examples "it can have shareable links" do |document_type, example_name|
  include ERB::Util

  before do
    @content_store_response = GovukSchemas::Example.find(document_type, example_name:)
  end

  it "gets its share links" do
    expected_share_url = url_encode(Plek.new.website_root + @content_store_response["base_path"])
    expected_share_links = [
      {
        href: "https://www.facebook.com/sharer/sharer.php?u=#{expected_share_url}",
        text: "Facebook",
        icon: "facebook",
      },
      {
        href: "https://twitter.com/share?url=#{expected_share_url}&text=#{url_encode(@content_store_response['title'])}",
        text: "Twitter",
        icon: "twitter",
      },
    ]

    expect(described_class.new(@content_store_response).share_links).to eq(expected_share_links)
  end
end
