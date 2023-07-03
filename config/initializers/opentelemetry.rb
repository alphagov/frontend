require "opentelemetry/sdk"
require "opentelemetry/exporter/otlp"
require "opentelemetry/instrumentation/all"
OpenTelemetry::SDK.configure do |c|
  c.service_name = "frontend"
  c.use_all # enables all instrumentation!
end
