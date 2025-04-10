RSpec.describe ContentsOutlinePresenter do
  subject(:contents_outline_presenter) { described_class.new(contents_outline) }

  let(:contents_outline) do
    ContentsOutline.new([
      {
        "id" => "item-1",
        "text" => "Item 1",
        "level" => 2,
        "headers" => [{ "id" => "sub-item-1", "text" => "Sub-Item 1", "level" => 3 }],
      },
      {
        "id" => "item-2",
        "text" => "Item 2",
        "level" => 2,
      },
    ])
  end

  describe "#for_contents_list_component" do
    it "renders the content outline suitable for the contents_list component" do
      expected = [
        {
          href: "#item-1",
          text: "Item 1",
          items: [
            { href: "#sub-item-1", text: "Sub-Item 1" },
          ],
        },
        {
          href: "#item-2",
          text: "Item 2",
        },
      ]

      expect(contents_outline_presenter.for_contents_list_component).to eq(expected)
    end
  end
end
