RSpec.describe FlexiblePage::FlexibleSection::RichContent do
  subject(:page_title) do
    described_class.new({
      "contents_list" => [
        { "href" => "#introduction", "text" => "Introduction" },
        { "href" => "#take_tour", "text" => "Take the tour" },
      ],
      "govspeak" => "<h2>Hello!</h2>",
      "image" => nil,
    }, FlexiblePage.new({}))
  end

  describe "#initialize" do
    it "sets the attributes from the contents hash" do
      expect(page_title.contents_list).to be_instance_of(ContentsList)
      expect(page_title.govspeak).to eq("<h2>Hello!</h2>")
    end
  end
end
