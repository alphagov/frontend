# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path("config/application", __dir__)
require "rake"
require "ci/reporter/rake/test_unit" if Rails.env.development? or Rails.env.test?
require "ci/reporter/rake/rspec" if Rails.env.development? or Rails.env.test?

Frontend::Application.load_tasks

Rake::Task["default"].clear
task default: [:spec, :test, :lint, "jasmine:ci"]
