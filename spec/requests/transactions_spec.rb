RSpec.describe "Transactions" do
  describe "GET show" do
    before do
      content_store_has_example_item("/foo", schema: "transaction")
    end

    it "sets the cache expiry headers" do
      get "/foo"

      expect(response).to honour_content_store_ttl
    end

    it "does not allow framing of transaction pages" do
      content_store_has_example_item("/foo", schema: "transaction")
      get "/foo"

      expect(response.headers["X-Frame-Options"]).to eq("SAMEORIGIN")
    end
  end

  context "when loading the jobsearch page" do
    let!(:content_item) { content_store_has_example_item("/jobsearch", schema: "transaction", example: "jobsearch") }

    it "responds with success" do
      get "/jobsearch"

      expect(response).to have_http_status(200)
    end

    it "loads the correct details" do
      get "/jobsearch"

      expect(assigns(:content_item).title).to eq(content_item["title"])
    end

    it "sets correct expiry headers" do
      get "/jobsearch"

      expect(response).to honour_content_store_ttl
    end
  end

  context "when a variant exists" do
    let!(:content_item) { content_store_has_example_item("/foo", schema: "transaction", example: "transaction-with-variants") }

    it "displays variant specific values where present" do
      get "/foo", params: { variant: "council-tax-bands-2-staging" }

      expect(assigns(:content_item).title).to eq(content_item.dig("details", "variants", 0, "title"))
      expect(assigns(:content_item).transaction_start_link).to eq(content_item.dig("details", "variants", 0, "transaction_start_link"))
    end

    it "displays normal value where variant does not specify value" do
      get "/foo", params: { variant: "council-tax-bands-2-staging" }

      expect(assigns(:content_item).more_information).to eq(content_item.dig("details", "more_information"))
    end
  end
end
