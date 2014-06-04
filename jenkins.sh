#!/bin/bash -x

set -e

export FACTER_govuk_platform=test
export RAILS_ENV=test
export DISPLAY=":99"
export GOVUK_APP_DOMAIN=dev.gov.uk

bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment
bundle exec rake stats
bundle exec rake ci:setup:testunit test
bundle exec rake assets:precompile
