# GOV.UK Frontend

Application to serve mainstream formats, the homepage, and search vertical for
the GOV.UK single domain.

## Live examples

### Formats

* https://www.gov.uk/benefit-cap (answer)
* https://www.gov.uk/britainisgreat (campaign)
* https://www.gov.uk/becoming-a-british-citizen (guide)
* https://www.gov.uk/settle-in-the-uk (simple smart answer)
* https://www.gov.uk/register-to-vote (transaction start page)
* https://www.gov.uk/foreign-travel-advice/afghanistan (foreign travel advice country page)
* https://www.gov.uk/help/cookies (help page)

### Hard-coded routes

* https://www.gov.uk/search?q=cabinet+office (search results page)
* https://www.gov.uk/ (homepage)
* https://www.gov.uk/tour (tour of GOV.UK)
* https://www.gov.uk/help (help index page)
* https://www.gov.uk/foreign-travel-advice (travel advice index page)

## Nomenclature

- Formats - our phrase for a type of content

## Technical documentation

A Ruby on Rails application that renders the citizen-facing part of formats
stored in the Content API. It looks up the passed in slug in the Content API.

It also serves the homepage (hard-coded route) and the search results vertical
(hard-coded route).

See `app/views/root` for some bespoke transaction start pages.

### Dependencies

- [alphagov/static](https://github.com/alphagov/static) - provides shared
  templates, styles, and JavaScript
- [alphagov/govuk_content_api](https://github.com/alphagov/govuk_content_api) -
  provides raw data for rendering formats
- [alphagov/panopticon](https://github.com/alphagov/panopticon) - (optionally)
  registers the application with Panoption

### Running the application

To run the application standalone, run
[static](https://github.com/alphagov/static) and execute the following command:

```
PLEK_SERVICE_STATIC_URI=http://127.0.0.1:3013 PLEK_SERVICE_CONTENTAPI_URI=https://www.gov.uk/api ./startup.sh
```

which uses the production
[content API](https://github.com/alphagov/govuk_content_api) and a local copy of
static.

To run in a full development stack (with DNS, all apps running etc.) just use
`./startup.sh`.

### Running the test suite

`bundle exec rake` runs the test suite.

#### JavaScript unit testing

The tests in
[test/javascripts](https://github.com/alphagov/frontend/tree/set-up-js-testing/test/javascripts)
will be run as part of the `test:javascript` task.

To run them in a browser on your local machine (useful for breakpointing):

1. run `INCLUDE_JS_TEST_ASSETS=1 bundle exec script/rails server -p 3150
   --environment=test` on your vm
2. open
   [test/javascripts/support/LocalTestRunner.html](https://github.com/alphagov/frontend/blob/set-up-js-testing/test/javascripts/support/LocalTestRunner.html)
   (as a static file) in your browser.
sadads
This relies on you being able to access the above server on
`http://www.dev.gov.uk:3150`.

## Licence

[MIT Licence](LICENCE.txt)
