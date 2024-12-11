RSpec.describe GetInvolved do
  before do
    stub_search_query(query: hash_including(filter_content_store_document_type: "open_consultation"), response: { "results" => [], "total" => 83 })
    stub_search_query(query: hash_including(filter_content_store_document_type: "closed_consultation"), response: { "results" => [], "total" => 110 })
    stub_search_query(query: hash_including(filter_content_store_document_type: "consultation_outcome"), response: { "results" => [consultation_result] })
    stub_search_query(query: hash_including(filter_content_store_document_type: "open_consultation", filter_end_date: "from: #{Time.zone.now.to_date}"), response: { "results" => [next_closing_consultation] })
  end

  let(:content_item) do
    GovukSchemas::Example.find("get_involved", example_name: "get_involved")
  end

  describe "#open_consultation_count" do
    it "returns the total number of open consultations" do
      model_instance = described_class.new(content_item)

      expect(model_instance.open_consultation_count).to eq(83)
    end
  end

  describe "#closed_consultation_count" do
    it "returns the total number of closed consultations" do
      model_instance = described_class.new(content_item)

      expect(model_instance.closed_consultation_count).to eq(110)
    end
  end

  describe "#consultation outcome" do
    it "returns the recent consultation outcome" do
      model_instance = described_class.new(content_item)

      expect(model_instance.recent_consultation_outcomes).to eq([consultation_result])
    end
  end

  describe "#next closing consultation" do
    it "returns the next closing consultation" do
      model_instance = described_class.new(content_item)

      expect(model_instance.next_closing_consultation).to eq(next_closing_consultation)
    end
  end
end

def stub_search_query(query:, response:)
  stub_request(:get, /\A#{Plek.new.find('search-api')}\/search.json/)
    .with(query:)
    .to_return(body: response.to_json)
end

def consultation_result
  {
    "title" => "Consulting on time zones",
    "public_timestamp" => "2024-10-14T00:00:00.000+01:00",
    "end_date" => "2024-10-14T00:00:00.000+01:00",
    "link" => "/consultation/link",
    "organisations" => [{
      "slug" => "ministry-of-justice",
      "link" => "/government/organisations/ministry-of-justice",
      "title" => "Ministry of Justice",
      "acronym" => "MoJ",
      "organisation_state" => "live",
    }],
  }
end

def next_closing_consultation
  {
    "title" => "Incorporating international rules",
    "public_timestamp" => "2023-11-14T00:00:00.000+01:00",
    "end_date" => "2024-11-14T00:00:00.000+01:00",
    "link" => "/consultation/link",
    "organisations" => [{
      "slug" => "ministry-of-justice",
      "link" => "/government/organisations/ministry-of-justice",
      "title" => "Ministry of Justice",
      "acronym" => "MoJ",
      "organisation_state" => "live",
    }],
  }
end
