RSpec.describe NotifyDeliveryMethod do
  describe "#deliver!" do
    it "calls Notify's send_email endpoint" do
      headers = { to: "x@y.com",
                  body: "Body content",
                  subject: "A subject line" }
      template_id = SecureRandom.uuid
      message = Mail::Message.new(headers)

      client = instance_double("Notifications::Client")
      allow(Notifications::Client).to receive(:new).and_return(client)

      expect(client).to receive(:send_email)
        .with(email_address: headers[:to],
              template_id: template_id,
              personalisation: {
                body: headers[:body],
                subject: headers[:subject],
              })

      NotifyDeliveryMethod.new(api_key: "api-key", template_id: template_id)
                          .deliver!(message)
    end
  end
end
