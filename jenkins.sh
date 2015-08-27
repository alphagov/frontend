#!/bin/bash -x

set -e

export FACTER_govuk_platform=test
export RAILS_ENV=test
export DISPLAY=":99"
export GOVUK_APP_DOMAIN=dev.gov.uk

bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment

# Lint changes introduced in this branch, but not for master
if [[ ${GIT_BRANCH} != "origin/master" ]]; then
  bundle exec govuk-lint-ruby \
    --rails \
    --display-cop-names \
    --display-style-guide \
    --diff \
    --cached \
    --format html --out rubocop-${GIT_COMMIT}.html \
    --format clang \
    app test lib config
fi

bundle exec rake stats
bundle exec rake ci:setup:testunit default
bundle exec rake assets:precompile
