if Rails.env.development? && ENV["DEBUGGER"] == "true"
  require "debug/session"
  Rails.logger.info "Starting debug session"
  # the port can be anything
  DEBUGGER__.open(port: "12345", host: "0.0.0.0")
end
