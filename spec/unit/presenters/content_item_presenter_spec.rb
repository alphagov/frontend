RSpec.describe ContentItemPresenter, type: :model do
  def subject(content_item)
    ContentItemPresenter.new(content_item.deep_stringify_keys!)
  end

  describe "#base_path" do
    it "returns the subject base path" do
      expect(subject(base_path: "foo").base_path).to eq("foo")
    end
  end

  describe "#in_beta" do
    it "returns false if the phase is live" do
      expect(subject(phase: "live").in_beta).to be false
    end

    it "returns true if the phase is beta" do
      expect(subject(phase: "beta").in_beta).to be true
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

  describe "#short_description" do
    it "returns nil for an empty subject" do
      expect(subject({}).short_description).to be_nil
    end
  end

  describe "#updated_at" do
    it "returns the subject public_updated_at" do
      datetime = 1.minute.ago
      expect(subject(public_updated_at: datetime.to_s).updated_at.to_i).to eq(datetime.to_i)
    end
  end

  describe "#locale" do
    it "returns the subject locale" do
      expect(subject(locale: "foo").locale).to eq("foo")
    end
  end
end
