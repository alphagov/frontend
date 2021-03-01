return if Rails.env.production?

require "pact/tasks"
require "pact/tasks/task_helper"

desc "Verify that Frontend honours all contracts in the pactfile created by a given branch of gds-api-adapters"
task "pact:verify:branch", [:branch_name] => :environment do |t, args|
  abort "Please provide a branch name. eg rake #{t.name}[my_feature_branch]" unless args[:branch_name]

  pact_version = args[:branch_name] == "master" ? args[:branch_name] : "branch-#{args[:branch_name]}"

  ClimateControl.modify GDS_API_ADAPTERS_PACT_VERSION: pact_version do
    Pact::TaskHelper.handle_verification_failure do
      Pact::TaskHelper.execute_pact_verify
    end
  end
end
