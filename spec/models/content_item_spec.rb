RSpec.describe ContentItem do
  let(:subject) { build(:content_item_with_data_attachments, schema_name: "fancy_page_type") }

  describe "#is_a_xxxx?" do
    it "returns true when called with the schema name of the object" do
      expect(subject.is_a_fancy_page_type?).to be true
    end

    it "returns false when called with a mismatching schema name" do
      expect(subject.is_a_place?).to be false
    end

    it "also handles is_an_xxxx?" do
      expect(subject.is_an_organisation?).to be false
    end

    it "still passes other missing methods to parent" do
      expect { subject.was_a_fancy_page_type? }.to raise_error(NoMethodError)
    end

    it "responds to the various methods" do
      expect(subject.respond_to?(:is_a_fancy_page_type?)).to be true
      expect(subject.respond_to?(:is_an_organisation?)).to be true
      expect(subject.respond_to?(:was_a_landing_page?)).to be false
    end
  end

  describe "#attachments" do
    it "loads the attachment data from the content item" do
      expect(subject.attachments.count).to eq(2)
      expect(subject.attachments[0].title).to eq("Data One")
    end
  end
end
