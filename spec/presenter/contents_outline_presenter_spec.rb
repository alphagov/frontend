RSpec.describe ContentsOutlinePresenter do
  subject(:contents_outline_presenter) { described_class.new(contents_outline) }

  let(:contents_outline) do
    ContentsOutline.new([
      {
        "id" => "item-1",
        "text" => "Item 1",
        "level" => 2,
        "headers" => [{ "id" => "nested-item-1", "text" => "Nested Item 1", "level" => 3 }],
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
            { href: "#nested-item-1", text: "Nested Item 1", items: [] },
          ],
        },
        {
          href: "#item-2",
          text: "Item 2",
          items: [],
        },
      ]

      expect(contents_outline_presenter.for_contents_list_component).to eq(expected)
    end

    context "when an outline text element ends with a colon" do
      let(:contents_outline) do
        ContentsOutline.new([
          {
            "id" => "item-1",
            "text" => "Item 1:",
          },
        ])
      end

      it "removes the trailing colon in the rendered text" do
        expect(contents_outline_presenter.for_contents_list_component.first[:text]).to eq("Item 1")
      end
    end
  end
end
