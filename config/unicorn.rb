require "govuk_app_config"
GovukUnicorn.configure(self)

worker_processes Integer(ENV.fetch("UNICORN_WORKER_PROCESSES", 4))
