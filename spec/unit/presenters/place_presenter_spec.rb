RSpec.describe PlacePresenter, type: :model do
  def subject(content_item)
    @subject ||= PlacePresenter.new(content_item.deep_stringify_keys!)
  end

  describe "#introduction" do
    it "shows the introduction" do
      expect(subject(details: { introduction: "foo" }).introduction).to eq("foo")
    end
  end

  describe "#more_information" do
    it "shows the more_information" do
      expect(subject(details: { more_information: "foo" }).more_information).to eq("foo")
    end
  end

  describe "#need_to_know" do
    it "shows the need to know" do
      expect(subject(details: { need_to_know: "foo" }).need_to_know).to eq("foo")
    end
  end

  describe "#place_type" do
    it "shows the place_type" do
      expect(subject(details: { place_type: "foo" }).place_type).to eq("foo")
    end
  end

  describe "#places" do
    it "shows the places" do
      places = [{ "address1" => "44", "address2" => "Foo Foo Forest", "url" => "http://www.example.com/foo_foo_foorentinafoo" }]
      expected = [{ "address1" => "44", "address2" => "Foo Foo Forest", "url" => "http://www.example.com/foo_foo_foorentinafoo", "text" => "http://www.example.com/foo_foo_foorentinafoo", "address" => "44, Foo Foo Forest" }]

      expect(PlacePresenter.new({}, places).places).to eq(expected)
    end
  end
end
