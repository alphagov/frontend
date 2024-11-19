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

  describe "#locale" do
    it "returns the subject locale" do
      expect(subject(locale: "foo").locale).to eq("foo")
    end
  end
end
