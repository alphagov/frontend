Rails.application.config.maintenance_mode = ENV["MAINTENANCE_MESSAGE"].present?
Rails.application.config.maintenance_message = ENV["MAINTENANCE_MESSAGE"]
