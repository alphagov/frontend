RSpec.describe LicenceTransactionPresenter, type: :model do
  def subject(content_item)
    LicenceTransactionPresenter.new(content_item.deep_stringify_keys!)
  end

  describe "#licence_transaction_continuation_link" do
    it "shows the link" do
      details = { details: { metadata: { licence_transaction_continuation_link: "https://continue-here.gov.uk" } } }

      expect(subject(details).licence_transaction_continuation_link).to eq("https://continue-here.gov.uk")
    end
  end

  describe "#licence_transaction_licence_identifier" do
    it "shows the identifier" do
      details = { details: { metadata: { licence_transaction_licence_identifier: "123" } } }

      expect(subject(details).licence_transaction_licence_identifier).to eq("123")
    end
  end

  describe "#licence_transaction_will_continue_on" do
    it "shows the continue on text" do
      details = { details: { metadata: { licence_transaction_will_continue_on: "Westminster Council" } } }

      expect(subject(details).licence_transaction_will_continue_on).to eq("Westminster Council")
    end
  end

  describe "#body" do
    it "shows the body" do
      details = { details: { body: "Overview of the licence" } }

      expect(subject(details).body).to eq("Overview of the licence")
    end
  end

  describe "#slug" do
    it "shows the slug" do
      expect(subject(base_path: "/find-licences/new-licence").slug).to eq("new-licence")
    end
  end
end
