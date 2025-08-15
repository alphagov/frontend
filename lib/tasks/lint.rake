desc "Run all linters"
task lint: :environment do
  Rails.logger.info "Logging OK"
  sh "bundle exec rubocop"
  sh "bundle exec erb_lint --lint-all"
  sh "yarn run lint"
end
