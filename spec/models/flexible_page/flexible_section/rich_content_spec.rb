RSpec.describe FlexiblePage::FlexibleSection::RichContent do
  subject(:rich_content) do
    described_class.new({
      "contents_list" => [
        { "id" => "introduction", "text" => "Introduction" },
        { "id" => "take_tour", "text" => "Take the tour" },
      ],
      "govspeak" => "<h2>Hello!</h2>",
      "image" => nil,
    }, FlexiblePage.new({}))
  end

  describe "#initialize" do
    it "sets the attributes from the contents hash" do
      expect(rich_content.contents_list).to be_instance_of(ContentsOutline)
      expect(rich_content.govspeak).to eq("<h2>Hello!</h2>")
    end
  end
end
