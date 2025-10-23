RSpec.describe ApplicationHelper do
  include ContentStoreHelpers

  describe "#page_title" do
    it "doesn't fail if the content_item titles are nil" do
      content_item = OpenStruct.new(title: nil)

      expect(page_title(content_item)).to be_truthy
    end
  end

  it "builds title from content items" do
    content_item = OpenStruct.new(title: "Title")

    expect(page_title(content_item)).to eq("Title - GOV.UK")
  end

  it "omits first part of title if content_item is omitted" do
    expect(page_title).to eq("GOV.UK")
  end

  describe "#current_path_without_query_string" do
    it "returns the path of the current request" do
      allow(self).to receive(:request).and_return(ActionDispatch::TestRequest.new("PATH_INFO" => "/foo/bar"))

      expect(current_path_without_query_string).to eq("/foo/bar")
    end

    it "returns the path of the current request stripping off any query string parameters" do
      allow(self).to receive(:request).and_return(ActionDispatch::TestRequest.new("PATH_INFO" => "/foo/bar?query=true"))

      expect(current_path_without_query_string).to eq("/foo/bar")
    end
  end

  describe "it doesn't show breadcrumbs" do
    describe "when the content item is a homepage" do
      let(:content_item) { ContentItem.new({ "schema_name" => "landing_page" }) }

      it "does not show breadcrumbs" do
        expect(show_breadcrumbs?(content_item)).to be(false)
      end
    end

    describe "when the content item is a landing page" do
      let(:content_item) { ContentItem.new({ "schema_name" => "a_different_page" }) }

      it "shows breadcrumbs" do
        expect(show_breadcrumbs?(content_item)).to be(true)
      end
    end

    describe "when landing_page is undefined" do
      let(:content_item) { ContentItem.new({}) }

      it "shows breadcrumbs" do
        expect(show_breadcrumbs?(content_item)).to be(true)
      end
    end
  end

  describe "iOS banner" do
    describe "when the page is in the list" do
      let(:content_item) { ContentItem.new({ "base_path" => "/state-pension" }) }

      it "shows the banner" do
        expect(show_ios_banner?).to be(true)
      end
    end

    describe "when the page is not in the list" do
      let(:content_item) { ContentItem.new({ "base_path" => "/government/speeches/charles-hendrys-speech-to-the-fuellers-lecture-25th-anniversary" }) }

      it "does not show the banner" do
        expect(show_ios_banner?).to be(false)
      end
    end

    describe "when the page does not have a base path" do
      let(:content_item) { ContentItem.new({}) }

      it "does not show the banner" do
        expect(show_ios_banner?).to be(false)
      end
    end

    describe "when the page does not have a content item" do
      let(:content_item) { nil }

      it "does not show the banner" do
        expect(show_ios_banner?).to be(false)
      end
    end
  end
end
