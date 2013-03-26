# This file is overwritten on deploy

if Rails.env.test?
  Rails.application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[Frontend (development)] ",
    :sender_address => %{"Frontend App" <frontend@example.com>},
    :exception_recipients => %w{exceptions@example.com}
end
