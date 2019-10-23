require "notifications/client"

class NotifyDeliveryMethod
  attr_reader :settings

  def initialize(settings)
    @settings = settings
  end

  def deliver!(mail)
    client.send_email(payload(mail))
  end

private

  def client
    @client ||= Notifications::Client.new(settings[:api_key])
  end

  def payload(mail)
    {
      email_address: mail.to.first,
      template_id: settings[:template_id],
      personalisation: {
        body: mail.body.raw_source,
        subject: mail.subject,
      },
    }
  end
end
