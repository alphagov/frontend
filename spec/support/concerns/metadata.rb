RSpec.shared_examples "it can have metadata" do |document_type, example_name|
  before do
    @example_doc = GovukSchemas::Example.find(document_type, example_name:)

    @example_doc["details"]["first_public_at"] = "2012-09-12T10:00:00+01:00"
    @example_doc["details"]["display_date"] = "2012-09-12T10:00:00+01:00"
    @example_doc["details"]["updated"] = "2016-02-18T15:45:44.000+00:00"
    @example_doc["links"] = {
      "organisations" => [
        {
          "title" => "Department for Environment, Food & Rural Affairs",
          "base_path" => "/government/organisations/department-for-environment-food-rural-affairs",
          "content_id" => "some-content-id",
        },
      ],
      "worldwide_organisations" => [
        {
          "title" => "British Embassy",
          "base_path" => "/government/world/organisations/british-embassy",
          "content_id" => "another-content-id",
        },
      ],
    }
  end

  it "knows it's publisher_metadata without pending stats announcement" do
    expect(described_class.new(@example_doc).publisher_metadata).to eq({
      first_published: "2012-09-12T10:00:00+01:00",
      from: [{ "base_path" => "/government/organisations/department-for-environment-food-rural-affairs", "content_id" => "some-content-id", "title" => "Department for Environment, Food & Rural Affairs" }, { "base_path" => "/government/world/organisations/british-embassy", "content_id" => "another-content-id", "title" => "British Embassy" }],
      last_updated: "2016-02-18T15:45:44.000+00:00",
      see_updates_link: true,
    })
  end

  context "when there is a pending stats announcement" do
    before do
      @example_doc["details"]["display_date"] = (Time.zone.now + 1.day).iso8601
    end

    it "knows it's publisher_metadata with pending stats announcement" do
      expect(described_class.new(@example_doc).publisher_metadata).to eq({
        first_published: "2012-09-12T10:00:00+01:00",
        from: [{ "base_path" => "/government/organisations/department-for-environment-food-rural-affairs", "content_id" => "some-content-id", "title" => "Department for Environment, Food & Rural Affairs" }, { "base_path" => "/government/world/organisations/british-embassy", "content_id" => "another-content-id", "title" => "British Embassy" }],
        last_updated: "2016-02-18T15:45:44.000+00:00",
      })
    end
  end
end
