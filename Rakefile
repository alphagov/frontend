# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

begin
  require "pact/tasks"
rescue LoadError
  # Pact isn't available in all environments
end

require File.expand_path("config/application", __dir__)
require "rake/testtask"

Rails.application.load_tasks

Rake::TestTask.new(:test_unit) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false
end

Rake::Task[:default].clear if Rake::Task.task_defined?(:default)
task default: %i[test_unit jasmine pact:verify lint]
