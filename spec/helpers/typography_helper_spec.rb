RSpec.describe TypographyHelper do
  include described_class
  include ERB::Util

  it "nbsp_between_last_two_words" do
    expect(nbsp_between_last_two_words("this and that")).to eq("this and&nbsp;that")
    expect(nbsp_between_last_two_words("this and that ")).to eq("this and&nbsp;that")
    expect(nbsp_between_last_two_words("this and that.")).to eq("this and&nbsp;that.")
    expect(nbsp_between_last_two_words("this and that. ")).to eq("this and&nbsp;that.")
    expect(nbsp_between_last_two_words("this and that\n\n")).to eq("this and&nbsp;that")
    expect(nbsp_between_last_two_words("multiline\nthis and that")).to eq("multiline\nthis and&nbsp;that")
    expect(nbsp_between_last_two_words("NCS is for 16 and 17 year olds.")).to eq("NCS is for 16 and 17 year&nbsp;olds.")
  end

  it "nbsp_between_last_two_words leaves alone single words" do
    expect(nbsp_between_last_two_words("this")).to eq("this")
  end

  it "nbsp_between_last_two_words isn't unsafe" do
    expect(nbsp_between_last_two_words("<b>this<b> & that thing")).to eq("&lt;b&gt;this&lt;b&gt; &amp; that&nbsp;thing")
    expect(nbsp_between_last_two_words("<b>this<b> &amp; that")).to eq("&lt;b&gt;this&lt;b&gt; &amp;&nbsp;that")
  end

  it "nbsp_between_last_two_words handles nil descriptions" do
    expect {
      nbsp_between_last_two_words(nil)
    }.not_to raise_error
  end
end
