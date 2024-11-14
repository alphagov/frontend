RSpec.describe ContentItemPresenter do
  def subject(content_item)
    described_class.new(content_item.deep_stringify_keys!)
  end

  describe "#base_path" do
    it "returns the subject base path" do
      expect(subject(base_path: "foo").base_path).to eq("foo")
    end
  end

  describe "#slug" do
    it "returns the subject slug" do
      expect(subject(base_path: "foo").slug).to eq("foo")
    end
  end

  describe "#format" do
    it "returns the subject format" do
      expect(subject(schema_name: "foo").format).to eq("foo")
    end
  end

  describe "#updated_at" do
    it "returns the subject public_updated_at" do
      datetime = 1.minute.ago
      expect(subject(public_updated_at: datetime.to_s).updated_at.to_i).to eq(datetime.to_i)
    end

    it "returns the subject public_updated_at" do
      expect(subject({}).updated_at).to be_nil
    end
  end

  describe "#locale" do
    it "returns the subject locale" do
      expect(subject(locale: "foo").locale).to eq("foo")
    end
  end
end
