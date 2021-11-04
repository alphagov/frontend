#!/bin/bash

bundle check || bundle install

if [[ $1 == "--live" ]] ; then
  GOVUK_APP_DOMAIN=www.gov.uk \
  GOVUK_WEBSITE_ROOT=https://www.gov.uk \
  PLEK_SERVICE_LICENSIFY_URI=${PLEK_SERVICE_LICENSIFY_URI-https://licensify.publishing.service.gov.uk} \
  PLEK_SERVICE_CONTENT_STORE_URI=${PLEK_SERVICE_CONTENT_STORE_URI-https://www.gov.uk/api} \
  PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-assets.publishing.service.gov.uk} \
  PLEK_SERVICE_IMMINENCE_URI=${PLEK_SERVICE_IMMINENCE_URI-https://imminence.publishing.service.gov.uk} \
  bundle exec rails s -p 3005
else
  echo "ERROR: other startup modes are not supported"
  echo ""
  echo "https://docs.publishing.service.gov.uk/manual/local-frontend-development.html"
  exit 1
fi
