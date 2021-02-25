return if Rails.env.production?

require "pact/tasks"
require "pact_broker/client/tasks"
require "pact/tasks/task_helper"
