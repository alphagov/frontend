# Frontend

Frontend renders the citizen-facing part of formats stored in the Content Store, and
some hard-coded routes including the GOV.UK homepage.

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
* https://www.gov.uk/help/cookies
* https://www.gov.uk/help/ab-testing
* https://www.gov.uk/foreign-travel-advice (travel advice index page)
* https://www.gov.uk/find-local-council
* https://www.gov.uk/roadmap (GOV.UK public facing roadmap)
* https://www.gov.uk/contact-electoral-registration-office (elections API)

### Licence finders

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

### Calendars

* https://www.gov.uk/bank-holidays
* https://www.gov.uk/when-do-the-clocks-change

### Misc

| URL  | Related views |
|-|-|
| http://www.gov.uk/school-term-holiday-dates<br>http://www.gov.uk/pay-council-tax<br>http://www.gov.uk/find-covid-19-lateral-flow-test-site<br>http://www.gov.uk/rubbish-collection-day<br>http://www.gov.uk/apply-council-tax-reduction<br>http://www.gov.uk/apply-for-disabled-bus-pass<br>http://www.gov.uk/apply-free-school-meals | `_base_page` <br>`local_transaction/search` |
| http://www.gov.uk/register-offices<br>http://www.gov.uk/ukonline-centre-internet-access-computer-training<br>http://www.gov.uk/find-theory-test-centre<br>http://www.gov.uk/id-scan-eu-settlement-scheme | `_base_page`<br>`place/show` |
| http://www.gov.uk/provide-journey-contact-details-before-travel-uk | `publication_metadata`<br>`_base_page`<br>`show` |
| http://www.gov.uk/contact-the-dvla/y/ | `flow` |
| http://www.gov.uk/check-a-passport-travel-europe | `_publication_metadata`<br>`_base_page`<br>`transaction/show` |
| http://www.gov.uk/renew-driving-licence-at-70    <br>http://www.gov.uk/check-mot-history    <br>http://www.gov.uk/mot-testing-service    <br>http://www.gov.uk/order-coronavirus-rapid-lateral-flow-tests   <br>http://www.gov.uk/check-legal-aid | `_base_page`<br>`transaction/show` |
## Nomenclature

- **format**: our phrase for a type of content
- **scope**: each type of calendar (eg daylight saving, bank holidays) is known as a scope. A scope has its own view templates, JSON data source and primary route.

## Technical documentation

Frontend is a Ruby on Rails application and should follow [our Rails app conventions](https://docs.publishing.service.gov.uk/manual/conventions-for-rails-applications.html).

### Dependencies

- [alphagov/static](https://github.com/alphagov/static) - provides shared templates, styles, and JavaScript
- [alphagov/content-store](https://github.com/alphagov/content-store) - provides raw data for rendering formats
- [alphagov/locations-api](https://github.com/alphagov/locations-api) - provides postcode lookups
- [alphagov/imminence](https://github.com/alphagov/imminence) - provides places lookups (e.g. for find-my-nearest)
- [alphagov/publishing-api](https://github.com/alphagov/publishing-api) - this app sends data to the content-store

### Running the application

You can use the [GOV.UK Docker environment](https://github.com/alphagov/govuk-docker) or the local `startup.sh` script to run the app. Read the [guidance on local frontend development](https://docs.publishing.service.gov.uk/manual/local-frontend-development.html) to find out more about each approach, before you get started.

If you are using GOV.UK Docker, remember to combine it with the commands that follow. See the [GOV.UK Docker usage instructions](https://github.com/alphagov/govuk-docker#usage) for examples.

If you are using the `startup.sh` script, first run [static]()https://github.com/alphagov/static) and execute the following command:

```
PLEK_SERVICE_STATIC_URI=http://static.dev.gov.uk ./startup.sh --live
```

which uses a local copy of static and content from production.

Note that you will have to have [GOV.UK Locations API](https://github.com/alphagov/locations-api) running locally. A valid dataset will have to be loaded for Locations API or postcode lookups will not succeed. This is part of the standard GOV.UK data replication steps.

### Running the test suite

```
bundle exec rake
```
### Further documentation

- [Calendars](docs/calendars.md)
- [Elections](docs/elections-api.md)

## Licence

[MIT Licence](LICENCE.txt)
