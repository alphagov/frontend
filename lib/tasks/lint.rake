desc "Run rubocop-govuk with similar params to CI"
task lint: :environment do
  sh "bundle exec rubocop"
end
