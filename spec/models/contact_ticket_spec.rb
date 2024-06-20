RSpec.describe ContactTicket, type: :model do
  include ValidatorHelper

  def valid_anonymous_ticket_details
    {
      textdetails: "some text",
      query: "cant-find",
      location: "all",
      url: "https://www.gov.uk/contact/govuk",
    }
  end

  def valid_named_ticket_details
    valid_anonymous_ticket_details.merge(name: "Joe Bloggs", email: "ab@c.com")
  end

  def anon_ticket(options = {})
    ContactTicket.new valid_anonymous_ticket_details.merge(options)
  end

  def named_ticket(options = {})
    ContactTicket.new valid_named_ticket_details.merge(options)
  end

  context "with a bad email address" do
    it "should not create a named contact" do
      bad_actors = [
        "12345@qq.com",
        "james@one.beameagle.top",
      ]
      bad_actors.each do |bad_actor|
        bad_ticket = ContactTicket.new valid_named_ticket_details.merge(name: "Bad Robot", email: bad_actor)
        expect(SupportTicketCreator).to_not receive(:send)
        # rubocop:disable Rails/SaveBang
        bad_ticket.save
        # rubocop:enable Rails/SaveBang
      end
    end
  end

  it "should validate anonymous tickets" do
    expect(anon_ticket).to be_valid
  end

  it "should validate named tickets" do
    expect(named_ticket).to be_valid
  end

  it "should return contact error with empty textdetails" do
    expect(anon_ticket(textdetails: "").errors[:textdetails].size).to eq(1)
  end

  it "should return contact error with too long name" do
    expect(named_ticket(name: build_random_string(1251)).errors[:name].size).to eq(1)
  end

  it "should return contact error with bad email" do
    expect(named_ticket(email: build_random_string(12)).errors[:email].size).to eq(1)
  end

  it "should not be valid if the email contains spaces" do
    expect(named_ticket(email: "abc @d.com").errors[:email].size).to eq(1)
  end

  it "should not be valid if the email has a dot at the end" do
    expect(named_ticket(email: "abc@d.com.").errors[:email].size).to eq(1)
  end

  it "should return contact error with too long email" do
    expect(named_ticket(email: "#{build_random_string 1251}@a.com").errors[:email].size).to eq(1)
  end

  it "should return contact error with location specific but without link" do
    expect(anon_ticket(location: "specific").errors[:link].size).to eq(1)
  end

  it "should return contact error with too long textdetails" do
    expect(anon_ticket(textdetails: build_random_string(1251)).errors[:textdetails].size).to eq(1)
  end

  it "should save the user agent and javascript state" do
    expected_user_agent = "Mozilla/5.0 (Windows NT 6.2; WOW64) Gobble-de-gook"
    expected_javascript_state = true

    ticket = anon_ticket(
      user_agent: expected_user_agent,
      javascript_enabled: expected_javascript_state,
    )

    expect(ticket.user_agent).to eq expected_user_agent
    expect(ticket.javascript_enabled).to eq expected_javascript_state
  end

  it "should set the javascript state to false by default" do
    expect(anon_ticket.javascript_enabled).to be_falsey
  end

  it "should make sure that a location is present" do
    expect(anon_ticket(location: "").errors[:location].size).to eq(1)
    expect(anon_ticket(location: nil).errors[:location].size).to eq(1)
  end
end
