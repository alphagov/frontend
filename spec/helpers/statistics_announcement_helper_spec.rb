RSpec.describe StatisticsAnnouncementHelper do
  describe "#nbsp_between_last_two_words" do
    it "adds nbsp correctly between the last two words" do
      expect(nbsp_between_last_two_words("this and that")).to eq("this and&nbsp;that")
      expect(nbsp_between_last_two_words("this and that ")).to eq("this and&nbsp;that")
      expect(nbsp_between_last_two_words("this and that.")).to eq("this and&nbsp;that.")
      expect(nbsp_between_last_two_words("this and that. ")).to eq("this and&nbsp;that.")
      expect(nbsp_between_last_two_words("this and that\n\n")).to eq("this and&nbsp;that")
      expect(nbsp_between_last_two_words("multiline\nthis and that")).to eq("multiline\nthis and&nbsp;that")
      expect(nbsp_between_last_two_words("NCS is for 16 and 17 year olds.")).to eq("NCS is for 16 and 17 year&nbsp;olds.")
    end

    it "leaves alone single words" do
      expect(nbsp_between_last_two_words("this")).to eq("this")
    end

    it "passes safe HTML" do
      expect(nbsp_between_last_two_words("<b>this<b> & that thing")).to eq("&lt;b&gt;this&lt;b&gt; &amp; that&nbsp;thing")
      expect(nbsp_between_last_two_words("<b>this<b> &amp; that")).to eq("&lt;b&gt;this&lt;b&gt; &amp;&nbsp;that")
    end

    it "handles nil descriptions" do
      expect(nbsp_between_last_two_words(nil)).to be_nil
    end
  end
end
