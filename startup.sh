#!/bin/bash

bundle install

if [[ $1 == "--live" ]] ; then
  GOVUK_APP_DOMAIN=www.gov.uk \
  GOVUK_WEBSITE_ROOT=https://www.gov.uk \
  PLEK_SERVICE_LICENSIFY_URI=${PLEK_SERVICE_LICENSIFY_URI-https://licensify.publishing.service.gov.uk} \
  PLEK_SERVICE_CONTENT_STORE_URI=${PLEK_SERVICE_CONTENT_STORE_URI-https://www.gov.uk/api} \
  PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-assets.publishing.service.gov.uk} \
  bundle exec unicorn -c ./config/unicorn.rb -p 3005
else
  bundle exec unicorn -c ./config/unicorn.rb -p 3005
fi
