RSpec.describe ApplicationHelper, type: :view do
  include ContentStoreHelpers

  def dummy_publication
    ContentItemPresenter.new(content_store_has_random_item(base_path: "/dummy"))
  end

  describe "#page_title" do
    it "doesn't contain consecutive pipes" do
      expect(page_title(dummy_publication)).not_to match(/\|\s*\|/)
    end

    it "doesn't fail if the publication titles are nil" do
      publication = OpenStruct.new(title: nil)

      expect(page_title(publication)).to be_truthy
    end
  end

  describe "#wrapper_class" do
    it "marks local transactions as a service" do
      local_transaction = OpenStruct.new(format: "local_transaction")

      expect(wrapper_class(local_transaction).split.include?("service")).to be true
    end
  end

  it "builds title from content items" do
    publication = OpenStruct.new(title: "Title")

    expect(page_title(publication)).to eq("Title - GOV.UK")
  end

  it "omits first part of title if publication is omitted" do
    expect(page_title).to eq("GOV.UK")
  end

  describe "#current_path_without_query_string" do
    it "returns the path of the current request" do
      allow(self).to receive(:request).and_return(ActionDispatch::TestRequest.new("PATH_INFO" => "/foo/bar"))

      expect(current_path_without_query_string).to eq("/foo/bar")
    end

    it "returns the path of the current request stripping off any query string parameters" do
      allow(self).to receive(:request).and_return(ActionDispatch::TestRequest.new("PATH_INFO" => "/foo/bar"))

      expect(current_path_without_query_string).to eq("/foo/bar")
    end
  end
end
