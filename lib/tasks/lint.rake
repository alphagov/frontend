desc "Run all linters"
task lint: :environment do
  sh "bundle exec rubocop"
  sh "bundle exec erb_lint --lint-all"
  sh "yarn run lint"
end
