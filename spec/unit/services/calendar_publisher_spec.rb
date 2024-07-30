RSpec.describe CalendarPublisher do
  let(:freeze_time) { Time.zone.now }
  let(:expected_content) do
    {
      base_path: "/bank-holidays",
      description: "Find out when bank holidays are in England, Wales, Scotland and Northern Ireland - including past and future bank holidays",
      details: { body: "" },
      document_type: "calendar",
      locale: "en",
      public_updated_at: freeze_time.rfc3339,
      publishing_app: "frontend",
      rendering_app: "frontend",
      routes: [
        { path: "/bank-holidays", type: "prefix" },
        { path: "/bank-holidays.json", type: "exact" },
      ],
      schema_name: "calendar",
      title: "UK bank holidays",
      update_type: "minor",
    }
  end

  around do |example|
    Timecop.freeze(freeze_time) do
      example.run
    end
  end

  it "publishing to publishing api" do
    publishing_api = double
    allow(GdsApi).to receive(:publishing_api).and_return(publishing_api)

    expect(publishing_api).to receive(:put_content).with("58f79dbd-e57f-4ab2-ae96-96df5767d1b2", expected_content)
    expect(publishing_api).to receive(:publish).with("58f79dbd-e57f-4ab2-ae96-96df5767d1b2", nil, { locale: :en })
    expect(publishing_api).to receive(:patch_links).with("58f79dbd-e57f-4ab2-ae96-96df5767d1b2", { links: ({ primary_publishing_organisation: %w[af07d5a5-df63-4ddc-9383-6a666845ebe9] }) })

    calendar = Calendar.find("bank-holidays")
    described_class.new(calendar).publish
  end
end
