[![Build Status](https://travis-ci.org/alphagov/frontend.png)](https://travis-ci.org/alphagov/frontend)

Front-end (and preview) app for single domain.

This serves documents from publisher & campaign pages as well as the following:

* `/browse` URLs
* `/search` URLs
* `/tour`
* `/foreign-travel-advice`

This is a basic list. For a full overview, see [config/routes.rb](https://github.com/alphagov/frontend/blob/master/config/routes.rb)

## JavaScript unit testing

The tests in [test/javascripts](https://github.com/alphagov/frontend/tree/set-up-js-testing/test/javascripts) will be run as part of the `test:javascript` task.

To run them in a browser on your local machine (useful for breakpointing):

1. run `INCLUDE_JS_TEST_ASSETS=1 bundle exec script/rails server -p 3150 --environment=test` on your vm
2. open [test/javascripts/support/LocalTestRunner.html](https://github.com/alphagov/frontend/blob/set-up-js-testing/test/javascripts/support/LocalTestRunner.html) (as a static file) in your browser.

This relies on you being able to access the above server on `http://www.dev.gov.uk:3150`.
