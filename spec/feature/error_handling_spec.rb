RSpec.describe "ErrorHandling", type: :feature do
  context "when the content store returns 403" do
    it "returns 403 status" do
      url = "#{content_store_endpoint}/content/slug"
      stub_request(:get, url).to_return(status: 403, headers: {})
      visit "/slug"

      expect(page.status_code).to eq(403)
    end
  end

  context "when the content store returns 404" do
    it "returns 404 status" do
      stub_content_store_does_not_have_item("/slug")
      visit "/slug"

      expect(page.status_code).to eq(404)
    end
  end

  context "when the content store returns 410" do
    it "returns 410 status" do
      stub_content_store_has_gone_item("/slug")
      visit "/slug"

      expect(page.status_code).to eq(410)
    end
  end

  context "when the application tries to retrieve an invalid URL from the content store" do
    it "returns 404 status" do
      content_store_throws_exception_for("/foo", GdsApi::InvalidUrl)
      visit "/foo"

      expect(page.status_code).to eq(404)
    end
  end

  context "when requesting gifs" do
    it "returns 404 status" do
      visit "/crisis-loans/refresh.gif"

      expect(page.status_code).to eq(404)

      visit "/refresh.gif"

      expect(page.status_code).to eq(404)

      visit "/pagerror.gif"

      expect(page.status_code).to eq(404)
    end
  end
end
