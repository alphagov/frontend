require "gds_zendesk/test_helpers"

RSpec.describe SupportTicketCreator do
  include GDSZendesk::TestHelpers

  let(:args) do
    {
      requester: {
        email: "someone@example.com",
        name: "Someone",
      },
      details: "Foo",
      link: "link",
      referrer: "Referrer",
      user_agent: "User agent",
      javascript_enabled: true,
    }
  end
  let(:support_ticket) do
    zendesk_has_user(email: args[:requester][:email], suspended: false)
    SupportTicketCreator.new(args)
  end

  describe ".call" do
    it "sends input via instance" do
      self.valid_zendesk_credentials = ZENDESK_CREDENTIALS
      stub_zendesk_ticket_creation
      zendesk_has_user(email: args[:requester][:email], suspended: false)

      expect { SupportTicketCreator.call(args) }.to_not raise_exception
    end

    it "ignores any extra keyword arguments" do
      self.valid_zendesk_credentials = ZENDESK_CREDENTIALS
      stub_zendesk_ticket_creation
      zendesk_has_user(email: args[:requester][:email], suspended: false)
      messy_args = args.merge(foo: "bar")

      expect { SupportTicketCreator.call(messy_args) }.to_not raise_exception
    end

    context "user is suspended" do
      before do
        self.valid_zendesk_credentials = ZENDESK_CREDENTIALS
        stub_zendesk_ticket_creation
        zendesk_has_user(email: args[:requester][:email], suspended: true)
      end

      it "doesn't raise an exception" do
        expect { SupportTicketCreator.call(args) }.to_not raise_exception
      end

      it "avoids creating a ticket" do
        client = GDSZendesk::Client.new(ZENDESK_CREDENTIALS).zendesk_client
        args[:zendesk_client] = client
        expect(client).to_not receive(:tickets)
        SupportTicketCreator.call(args)
      end

      it "increments the GovukStatsd" do
        expect(GovukStatsd).to receive(:increment).with("report_a_problem.submission_from_suspended_user").once
        SupportTicketCreator.call(args)
      end
    end
  end

  describe "#send" do
    it "sends payload to gov uk zendesk" do
      self.valid_zendesk_credentials = ZENDESK_CREDENTIALS
      stub_zendesk_ticket_creation(support_ticket.payload)

      expect { support_ticket.send }.to_not raise_exception
    end
  end

  describe "#payload" do
    it "includes hardcoded subject" do
      expect(support_ticket.payload[:subject]).to eq("Named contact")
    end

    it "includes dynamic subject if link provided" do
      args[:link] = "https://www.gov.uk/browse/visas-immigration"
      expect(support_ticket.payload[:subject]).to eq("Named contact about /browse/visas-immigration")
    end

    it "includes hardcoded tags" do
      expect(support_ticket.payload[:tags]).to eq(%w[public_form named_contact])
    end

    it "includes hardcoded priority" do
      expect(support_ticket.payload[:priority]).to eq("normal")
    end

    it "includes 'comment' containing generated body" do
      body = <<~MULTILINE_STRING
        [Requester]
        Someone <someone@example.com>

        [Details]
        Foo

        [Link]
        link

        [Referrer]
        Referrer

        [User agent]
        User agent

        [JavaScript Enabled]
        true
      MULTILINE_STRING

      expect(support_ticket.payload[:comment][:body]).to eq(body)
    end

    it "defaults to 'Unknown' for referrer and user agent" do
      args.delete(:referrer)
      args.delete(:user_agent)
      body = <<~MULTILINE_STRING
        [Requester]
        Someone <someone@example.com>

        [Details]
        Foo

        [Link]
        link

        [Referrer]
        Unknown

        [User agent]
        Unknown

        [JavaScript Enabled]
        true
      MULTILINE_STRING

      expect(support_ticket.payload[:comment][:body]).to eq(body)
    end
  end
end
