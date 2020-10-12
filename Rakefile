# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path("config/application", __dir__)
require "rake"
require "ci/reporter/rake/test_unit" if Rails.env.development? || Rails.env.test?
require "ci/reporter/rake/rspec" if Rails.env.development? || Rails.env.test?

Frontend::Application.load_tasks

# RSpec shoves itself into the default task without asking, which confuses the ordering.
# https://github.com/rspec/rspec-rails/blob/eb3377bca425f0d74b9f510dbb53b2a161080016/lib/rspec/rails/tasks/rspec.rake#L6
Rake::Task["default"].clear

task default: [:lint, :spec, :test, "jasmine:ci"]
