require "notify_delivery_method"

ActionMailer::Base.add_delivery_method :notify, NotifyDeliveryMethod,
                                       api_key: Rails.application.secrets.notify_api_key,
                                       template_id: ENV["GOVUK_NOTIFY_TEMPLATE_ID"]
