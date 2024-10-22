RSpec.describe LinkHelper do
  include LinkHelper

  describe "#govuk_styled_link" do
    let(:text) { "Some text" }
    let(:path) { "/path" }

    context "when there is no link path" do
      it "returns the text" do
        expect(govuk_styled_link(text)).to eq(text)
      end
    end

    context "when there is a link path" do
      it "returns a styled anchor element" do
        expected = "<a href='/path' class='govuk-link'>Some text</a>"

        expect(govuk_styled_link(text, path:)).to eq(expected)
      end

      it "styles the link as inverse when a inverse flag is passed" do
        expected = "<a href='/path' class='govuk-link govuk-link--inverse'>Some text</a>"

        expect(govuk_styled_link(text, path:, inverse: true)).to eq(expected)
      end
    end
  end
end
