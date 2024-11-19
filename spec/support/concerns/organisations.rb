RSpec.shared_examples "it can have organisations" do |schema|
  before do
    @content_store_response = GovukSchemas::Example.find(schema, example_name: schema)
    @content_store_response["details"]["emphasised_organisations"] = %w[11234500]
    @content_store_response["links"]["organisations"] = [
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

  it "knows it has organisations" do
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

    expect(described_class.new(@content_store_response).linkable_organisations).to eq(expected_result)
  end
end
