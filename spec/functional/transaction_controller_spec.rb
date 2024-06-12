RSpec.describe TransactionController, type: :controller do
  include GovukAbTesting::RspecHelpers

  context "GET show" do
    context "for live content" do
      before do
        @content_item = content_store_has_example_item("/foo", schema: "transaction")
      end

      it "sets the cache expiry headers" do
        get(:show, params: { slug: "foo" })

        honours_content_store_ttl
      end
    end

    it "does not allow framing of transaction pages" do
      content_store_has_example_item("/foo", schema: "transaction")
      get(:show, params: { slug: "foo" })

      expect(@response.headers["X-Frame-Options"]).to eq("DENY")
    end
  end

  context "loading the jobsearch page" do
    before do
      @content_item = content_store_has_example_item("/jobsearch", schema: "transaction", example: "jobsearch")
    end

    it "responds with success" do
      get(:show, params: { slug: "jobsearch" })

      assert_response(:success)
    end

    it "loads the correct details" do
      get(:show, params: { slug: "jobsearch" })

      expect(assigns(:publication).title).to eq(@content_item["title"])
    end

    it "sets correct expiry headers" do
      get(:show, params: { slug: "jobsearch" })

      honours_content_store_ttl
    end
  end

  context "given a welsh version exists" do
    before do
      content_store_has_example_item("/chwilio-am-swydd", schema: "transaction", example: "chwilio-am-swydd")
    end

    it "sets the locale to welsh" do
      expect(I18n).to receive(:locale=).with(:en)
      expect(I18n).to receive(:locale=).with("cy")

      get(:show, params: { slug: "chwilio-am-swydd" })
    end
  end

  context "given a variant exists" do
    context "for live content" do
      before do
        @content_item = content_store_has_example_item("/foo", schema: "transaction", example: "transaction-with-variants")
      end

      it "displays variant specific values where present" do
        get(:show, params: { slug: "foo", variant: "council-tax-bands-2-staging" })

        expect(assigns(:publication).title).to eq(@content_item.dig("details", "variants", 0, "title"))
        expect(assigns(:publication).transaction_start_link).to eq(@content_item.dig("details", "variants", 0, "transaction_start_link"))
      end

      it "displays normal value where variant does not specify value" do
        get(:show, params: { slug: "foo", variant: "council-tax-bands-2-staging" })

        expect(assigns(:publication).more_information).to eq(@content_item.dig("details", "more_information"))
      end
    end
  end
end
