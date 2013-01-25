# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
ENV["GOVUK_APP_DOMAIN"] = ENV.fetch("GOVUK_APP_DOMAIN", "dev.gov.uk")
ENV["GOVUK_WEBSITE_ROOT"] = ENV.fetch("GOVUK_WEBSITE_ROOT", "http://www.dev.gov.uk")

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'ci/reporter/rake/test_unit' if Rails.env.development? or Rails.env.test?
Frontend::Application.load_tasks
