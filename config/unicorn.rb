require "govuk_app_config/govuk_unicorn"
GovukUnicorn.configure(self)

worker_processes Integer(ENV.fetch("UNICORN_WORKER_PROCESSES", 4))
