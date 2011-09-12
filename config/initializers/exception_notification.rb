unless Rails.env.development? or Rails.env.test?
  Publisher::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[Front End] ",
    :sender_address => %{"Winston Smith-Churchill" <winston@alphagov.co.uk>},
    :exception_recipients => %w{dev@alphagov.co.uk}
end