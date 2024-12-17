RSpec.shared_examples "it can have worldwide organisations" do |schema|
  let(:content_store_response) { GovukSchemas::Example.find(schema, example_name: schema) }

  before do
    content_store_response["links"]["worldwide_organisations"] = [
      {
        "analytics_identifier" => "8888",
        "content_id" => "11234500",
        "api_path" => "/api/content/government/organisations/uk-health-security-agency",
        "api_url" => "https://www.gov.uk/api/content/government/organisations/uk-health-security-agency",
        "base_path" => "/government/organisations/uk-health-security-agency",
        "document_type" => "organisation",
        "title" => "UK Health Security Agency",
        "web_url" => "https://www.gov.uk/government/organisations/uk-health-security-agency",
      },
      {
        "analytics_identifier" => "8888",
        "content_id" => "100",
        "api_path" => "/api/content/government/organisations/blah-blah",
        "api_url" => "https://www.gov.uk/api/content/government/organisations/blah-blah",
        "base_path" => "/government/organisations/blah-blah",
        "document_type" => "organisation",
        "title" => "UK Health Security Agency",
        "web_url" => "https://www.gov.uk/government/organisations/blah-blah",
      },
    ]
  end

  it "knows it has worldwide organisations" do
    expected_result = [
      {
        "analytics_identifier" => "8888",
        "content_id" => "11234500",
        "api_path" => "/api/content/government/organisations/uk-health-security-agency",
        "api_url" => "https://www.gov.uk/api/content/government/organisations/uk-health-security-agency",
        "base_path" => "/government/organisations/uk-health-security-agency",
        "document_type" => "organisation",
        "title" => "UK Health Security Agency",
        "web_url" => "https://www.gov.uk/government/organisations/uk-health-security-agency",
      },
      {
        "analytics_identifier" => "8888",
        "api_path" => "/api/content/government/organisations/blah-blah",
        "api_url" => "https://www.gov.uk/api/content/government/organisations/blah-blah",
        "base_path" => "/government/organisations/blah-blah",
        "content_id" => "100",
        "document_type" => "organisation",
        "title" => "UK Health Security Agency",
        "web_url" => "https://www.gov.uk/government/organisations/blah-blah",
      },
    ]

    expect(described_class.new(content_store_response).worldwide_organisations).to eq(expected_result)
  end
end
