RSpec.describe PlacePresenter do
  describe "#places" do
    it "shows the places" do
      places = [{ "address1" => "44", "address2" => "Foo Foo Forest", "url" => "http://www.example.com/foo_foo_foorentinafoo" }]
      expected = [{ "address1" => "44", "address2" => "Foo Foo Forest", "url" => "http://www.example.com/foo_foo_foorentinafoo", "text" => "http://www.example.com/foo_foo_foorentinafoo", "address" => "44, Foo Foo Forest" }]

      expect(described_class.new({}, places).places).to eq(expected)
    end
  end
end
