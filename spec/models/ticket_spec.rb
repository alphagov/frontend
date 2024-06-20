RSpec.describe Ticket, type: :model do
  it { is_expected.to allow_value("https://www.gov.uk/done/whatever").for(:url) }
  it { is_expected.not_to be_spam }

  it "should validate the length of URLs" do
    expect(Ticket.new(url: "https://www.gov.uk/#{'a' * 2048}").errors[:url].size).to eq(1)
  end

  it "should validate the length of the user agent" do
    expect(Ticket.new(user_agent: "Mozilla #{'a' * 2048}").errors[:user_agent].size).to eq(1)
  end

  it "should filter 'url' to either nil or a valid URL" do
    expect(Ticket.new(url: "https://www.gov.uk").url).to eq("https://www.gov.uk")
    expect(Ticket.new(url: "http://bla.example.org:9292/méh/fào?bar").url).to be_nil
    expect(Ticket.new(url: nil).url).to be_nil
  end

  it "should add the website root to relative URLs" do
    expect(Ticket.new(url: "/relative/url").url).to eq("#{Plek.new.website_root}/relative/url")
  end

  it "should filter 'referrer' to either nil or a valid URL" do
    expect(Ticket.new(referrer: "https://www.gov.uk").referrer).to eq("https://www.gov.uk")
    expect(Ticket.new(referrer: "http://bla.example.org:9292/méh/fào?bar").referrer).to be_nil
    expect(Ticket.new(referrer: nil).referrer).to be_nil
  end

  it "should treat a 'unknown' referrer as nil" do
    expect(Ticket.new(referrer: "unknown").referrer).to be_nil
  end
end
