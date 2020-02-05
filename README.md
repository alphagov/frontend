<h1>GOV.UK Mainstream, Home & Search Frontend</h1>

<p>Application to serve some mainstream formats and the homepage for GOV.UK.</p>

## Live examples

### Formats

Simple smart answer
* https://www.gov.uk/settle-in-the-uk

Transaction start pages:
 * https://www.gov.uk/register-to-vote
 * https://www.gov.uk/vehicle-tax
 * https://www.gov.uk/find-a-job

### Hard-coded routes

* https://www.gov.uk/ (homepage)
* https://www.gov.uk/tour (tour of GOV.UK)
* https://www.gov.uk/help (help index page)
* https://www.gov.uk/foreign-travel-advice (travel advice index page)
* https://www.gov.uk/find-local-council
* https://www.gov.uk/help/ab-testing
* https://www.gov.uk/passport-interview-office

### Licence finders

Some examples:

* https://www.gov.uk/riding-establishment-licence
* https://www.gov.uk/premises-licence
* https://www.gov.uk/temporary-events-notice
* https://www.gov.uk/apply-skip-permit
* https://www.gov.uk/street-collection-licence
* https://www.gov.uk/zoo-licence
* https://www.gov.uk/premises-licence-scotland
* https://www.gov.uk/house-to-house-collection-licence
* https://www.gov.uk/public-charitable-collection-permit-scotland
* https://www.gov.uk/late-hours-catering-licence-scotland
* https://www.gov.uk/food-business-registration
* https://www.gov.uk/cooling-tower-notification
* https://www.gov.uk/performing-animals-registration

### Transaction done pages

* https://www.gov.uk/done/transaction-finished
* https://www.gov.uk/done/driving-transaction-finished

### Transaction done with survey pages

Standard survey:

* https://www.gov.uk/done/check-settled-status

Assisted digital satisfaction surveys:

* https://www.gov.uk/done/register-flood-risk-exemption
* https://www.gov.uk/done/waste-carrier-or-broker-registration
* https://www.gov.uk/done/register-waste-exemption

## Nomenclature

- Formats - our phrase for a type of content

## Technical documentation

Frontend is a Ruby on Rails application that renders the citizen-facing part of formats stored in the Content Store. It looks up the passed-in slug in the Content Store.

It also serves the homepage as a hard-coded route.

See `app/views/root` for some bespoke transaction start pages.

### Dependencies

- [alphagov/static](https://github.com/alphagov/static) - provides shared templates, styles, and JavaScript
- [alphagov/content-store](https://github.com/alphagov/content-store) - provides raw data for rendering formats
- [alphagov/mapit](https://github.com/alphagov/mapit) - provides postcode lookups
- [alphagov/imminence](https://github.com/alphagov/imminence) - provides places lookups (e.g. for find-my-nearest)

### Running the application

To run the application standalone, run [static](https://github.com/alphagov/static) and execute the following command:

```
PLEK_SERVICE_STATIC_URI=http://127.0.0.1:3013 ./startup.sh
```

which uses a local copy of static.

Note that you will have to have [GOV.UK Mapit](https://github.com/alphagov/mapit) running locally. A valid dataset will have to be loaded for Mapit or postcode lookups will not succeed. This is part of the standard GOV.UK data replication steps.

To run in a full development stack (with DNS, all apps running etc.) use`./startup.sh`.

If you are using the GDS development virtual machine then the application will be available on the host at http://frontend.dev.gov.uk/

### Running the test suite

`bundle exec rake` runs the test suite.

#### JavaScript unit testing

The tests in [test/javascripts](https://github.com/alphagov/frontend/tree/set-up-js-testing/test/javascripts) will be run as part of the `test:javascript` task.

To run them in a browser on your local machine (useful for breakpointing):

1. On your VM, run:
  ```sh
  INCLUDE_JS_TEST_ASSETS=1 bundle exec script/rails server -p 3150  --environment=test
  ```

2. Open [test/javascripts/support/LocalTestRunner.html](https://github.com/alphagov/frontend/blob/set-up-js-testing/test/javascripts/support/LocalTestRunner.html) (as a static file) in your browser.

This relies on you being able to access the above server on `http://www.dev.gov.uk:3150`.

## Licence

[MIT Licence](LICENCE.txt)
