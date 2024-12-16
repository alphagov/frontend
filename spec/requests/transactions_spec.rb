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

      expect(response.headers["X-Frame-Options"]).to eq("DENY")
    end
  end

  context "when loading the jobsearch page" do
    let!(:content_item) { content_store_has_example_item("/jobsearch", schema: "transaction", example: "jobsearch") }

    it "responds with success" do
      get "/jobsearch"

      assert_response(:success)
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

  context "when a welsh version exists" do
    before do
      content_store_has_example_item("/chwilio-am-swydd", schema: "transaction", example: "chwilio-am-swydd")
    end

    it "sets the locale to welsh" do
      expect(I18n).to receive(:locale=).with(:en).exactly(3).times # TODO: Why 3 times in a request, only 1 in a controller?
      expect(I18n).to receive(:locale=).with("cy")

      get "/chwilio-am-swydd"
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
