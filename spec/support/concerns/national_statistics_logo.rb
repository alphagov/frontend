RSpec.shared_examples "it supports the national statistics logo" do |content_item_class|
  subject(:presenter) { described_class.new(content_item) }

  context "when the content_item#national_statistics? is false" do
    let(:content_item) { instance_double(content_item_class, national_statistics?: false) }

    it "returns nil" do
      expect(presenter.logo).to be_nil
    end
  end

  context "when the content_item#national_statistics? is true but it's not in English/Welsh" do
    let(:content_item) { instance_double(content_item_class, national_statistics?: true, locale: "ar-ps") }

    it "returns nil" do
      expect(presenter.logo).to be_nil
    end
  end

  context "when the content_item#national_statistics? is true and locale is English" do
    let(:content_item) { instance_double(content_item_class, national_statistics?: true, locale: "en") }

    it "returns the English logo" do
      expect(presenter.logo).to eq({
        path: "accredited-official-statistics-en.png",
        alt_text: "Accredited official statistics",
      })
    end
  end

  context "when the content_item#national_statistics? is true and locale is Welsh" do
    let(:content_item) { instance_double(content_item_class, national_statistics?: true, locale: "cy") }

    it "returns the Welsh logo" do
      expect(presenter.logo).to eq({
        path: "accredited-official-statistics-cy.png",
        alt_text: "Ystadegau swyddogol achrededig",
      })
    end
  end
end
