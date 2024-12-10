RSpec.shared_examples "it can be updated" do |schema|
  before do
    @example_doc = GovukSchemas::Example.find(schema, example_name: schema)
    @example_doc["public_updated_at"] = "2024-07-16T12:36:44Z"
    @example_doc["first_public_at"] = "2024-05-23T00:00:00.000+01:00"
    @example_doc["details"]["change_history"] = [
      {
        "note" => "Added the PDF version of the case study.",
        "public_timestamp" => "2024-06-13T14:33:09.000+01:00",
      },
      {
        "note" => "First published.",
        "public_timestamp" => "2024-05-23T00:00:00.000+01:00",
      },
    ]
  end

  it "knows it's updated" do
    expect(described_class.new(@example_doc).updated).to eq "2024-07-16T12:36:44Z"
  end

  it "knows it's history" do
    expect(described_class.new(@example_doc).history).to eq([
      {
        display_time: "2024-06-13T14:33:09.000+01:00",
        note: "Added the PDF version of the case study.",
        timestamp: "2024-06-13T14:33:09.000+01:00",
      },
      {
        display_time: "2024-05-23T00:00:00.000+01:00",
        note: "First published.",
        timestamp: "2024-05-23T00:00:00.000+01:00",
      },
    ])
  end

  context "when there are no updates" do
    before do
      @example_doc["public_updated_at"] = nil
      @example_doc["first_public_at"] = nil
    end

    it "returns nil for updated" do
      expect(described_class.new(@example_doc).updated).to be_falsey
    end

    it "returns an empty array for history" do
      expect(described_class.new(@example_doc).history).to eq([])
    end
  end
end
