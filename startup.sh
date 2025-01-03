#!/bin/bash

bundle check || bundle install

if [[ $1 == "--live" ]] ; then
  ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE=true \
  GOVUK_APP_DOMAIN=www.gov.uk \
  GOVUK_WEBSITE_ROOT=https://www.gov.uk \
  GOVUK_PROXY_STATIC_ENABLED=true \
  PLEK_SERVICE_LICENSIFY_URI=${PLEK_SERVICE_LICENSIFY_URI-https://licensify.publishing.service.gov.uk} \
  PLEK_SERVICE_CONTENT_STORE_URI=${PLEK_SERVICE_CONTENT_STORE_URI-https://www.gov.uk/api} \
  PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-https://assets.publishing.service.gov.uk} \
  PLEK_SERVICE_SEARCH_API_URI=${PLEK_SERVICE_SEARCH_API_URI-https://www.gov.uk/api} \
  PLEK_SERVICE_PLACES_MANAGER_URI=${PLEK_SERVICE_PLACES_MANAGER_URI-https://places-manager.publishing.service.gov.uk} \
  ./bin/dev
else
  echo "ERROR: other startup modes are not supported"
  echo ""
  echo "https://docs.publishing.service.gov.uk/manual/local-frontend-development.html"
  exit 1
fi
