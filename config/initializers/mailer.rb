require "notify_delivery_method"
ActionMailer::Base.add_delivery_method :notify, NotifyDeliveryMethod
