require "govuk_app_config/govuk_puma"
require "prometheus_exporter"
require "prometheus_exporter/instrumentation"

GovukPuma.configure_rails(self)

# this produces a warning, because it's (intentionally) not running in a forked thread
PrometheusExporter::Instrumentation::Process.start(type: "main")

# these _are_ running in forks
after_worker_boot do
  PrometheusExporter::Instrumentation::Puma.start
  PrometheusExporter::Instrumentation::Process.start(type: "web")
end
