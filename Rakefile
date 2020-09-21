# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path("config/application", __dir__)
require "rake"
require "ci/reporter/rake/test_unit" if Rails.env.development? || Rails.env.test?
require "ci/reporter/rake/rspec" if Rails.env.development? || Rails.env.test?
require "rake/testtask"

Frontend::Application.load_tasks

# RSpec goes and clobbers the normal :test task without asking, so we have to rename it.
# https://github.com/rspec/rspec-rails/blob/eb3377bca425f0d74b9f510dbb53b2a161080016/lib/rspec/rails/tasks/rspec.rake#L3
Rake::TestTask.new(:test_unit) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false
end

# RSpec shoves itself into the default task without asking, which confuses the ordering.
# https://github.com/rspec/rspec-rails/blob/eb3377bca425f0d74b9f510dbb53b2a161080016/lib/rspec/rails/tasks/rspec.rake#L6
Rake::Task["default"].clear

# Combined coverage only works if RSpec come after Minitest. Using two frameworks sucks.
# https://github.com/simplecov-ruby/simplecov#merging-results
task default: [:lint, :test_unit, :spec, "jasmine:ci"]
