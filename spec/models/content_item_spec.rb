RSpec.describe ContentItem do
  subject(:content_item) { build(:content_item_with_data_attachments, schema_name: "fancy_page_type") }

  describe "ordered_related_items attribute" do
    it "leaves ordered_related_items if set" do
      subject = described_class.new(
        {
          "links" => {
            "ordered_related_items" => [1, 2],
            "suggested_ordered_related_items" => [3, 4],
          },
        },
      )

      expect(subject.to_h["links"]["ordered_related_items"]).to eq([1, 2])
    end

    it "uses suggested_ordered_related_items if no ordered_related_items" do
      subject = described_class.new(
        {
          "links" => {
            "suggested_ordered_related_items" => [3, 4],
          },
        },
      )

      expect(subject.to_h["links"]["ordered_related_items"]).to eq([3, 4])
    end

    it "returns an empty set if neither key is set" do
      subject = described_class.new(
        {
          "links" => {},
        },
      )

      expect(subject.to_h["links"]["ordered_related_items"]).to eq([])
    end

    it "returns an empty set if ordered_related_items_overrides is present" do
      subject = described_class.new(
        {
          "links" => {
            "ordered_related_items" => [1, 2],
            "ordered_related_items_overrides" => "true",
          },
        },
      )

      expect(subject.to_h["links"]["ordered_related_items"]).to eq([])
    end
  end

  describe "#is_a_xxxx?" do
    it "returns true when called with the schema name of the object" do
      expect(content_item.is_a_fancy_page_type?).to be true
    end

    it "returns false when called with a mismatching schema name" do
      expect(content_item.is_a_place?).to be false
    end

    it "also handles is_an_xxxx?" do
      expect(content_item.is_an_organisation?).to be false
    end

    it "still passes other missing methods to parent" do
      expect { content_item.was_a_fancy_page_type? }.to raise_error(NoMethodError)
    end

    it "responds to the various methods" do
      expect(content_item.respond_to?(:is_a_fancy_page_type?)).to be true
      expect(content_item.respond_to?(:is_an_organisation?)).to be true
      expect(content_item.respond_to?(:was_a_landing_page?)).to be false
    end
  end

  describe "#attachments" do
    it "loads the attachment data from the content item" do
      expect(content_item.attachments.count).to eq(4)
      expect(content_item.attachments[0].title).to eq("Data One")
    end
  end

  describe "#available_translations?" do
    subject(:content_item) { described_class.new(links) }

    context "when there are multiple translations" do
      let(:links) do
        {
          "links" => {
            "available_translations" => [
              { "locale" => "cy" },
              { "locale" => "en" },
            ],
          },
        }
      end

      it "returns true" do
        expect(content_item.available_translations?).to be true
      end
    end

    context "when there are only English translations" do
      let(:links) do
        {
          "links" => {
            "available_translations" => [
              { "locale" => "en" },
            ],
          },
        }
      end

      it "returns false" do
        expect(content_item.available_translations?).to be false
      end
    end

    context "when there are no translations" do
      let(:links) do
        {
          "links" => {},
        }
      end

      it "returns false" do
        expect(content_item.available_translations?).to be false
      end
    end
  end

  describe "#available_translations" do
    subject(:content_item) do
      described_class.new(
        {
          "links" => {
            "available_translations" => [
              { "locale" => "cy" },
              { "locale" => "en" },
            ],
          },
        },
      )
    end

    it "returns sorted translations with default translation at the top" do
      expect(content_item.available_translations).to eq([
        { "locale" => "en" },
        { "locale" => "cy" },
      ])
    end
  end

  describe "#contributors" do
    subject(:content_item) { described_class.new(content_store_response) }

    let(:content_store_response) { GovukSchemas::Example.find("answer", example_name: "answer") }

    it "returns the organisations base_path and title" do
      expect(content_item.contributors.count).to eq(1)
      expect(content_item.contributors.first.title).to eq(content_store_response.dig("links", "organisations", 0, "title"))
      expect(content_item.contributors.first.base_path).to eq(content_store_response.dig("links", "organisations", 0, "base_path"))
    end
  end

  describe "#meta_section" do
    subject(:content_item) do
      described_class.new(
        {
          "links" => {
            "parent" => [
              {
                "links" => {
                  "parent" => [
                    {
                      "title" => "Title of the parent's parent link",
                    },
                  ],
                },
              },
              "title" => "Title of the parent link",
            ],
          },
        },
      )
    end

    it "returns the title of the top parent link in lowercase" do
      expect(content_item.meta_section).to eq("title of the parent's parent link")
    end
  end

  describe "#organisations" do
    subject(:content_item) { described_class.new(content_store_response) }

    let(:content_store_response) do
      GovukSchemas::Example.find("answer", example_name: "answer")
    end

    it "gets all organisations linked to the content item" do
      expect(content_item.organisations.count).to eq(content_store_response.dig("links", "organisations").count)
      expect(content_item.organisations.first.title)
       .to eq(content_store_response.dig("links", "organisations", 0, "title"))
    end
  end
end
