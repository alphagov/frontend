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
* https://www.gov.uk/help/cookies
* https://www.gov.uk/help/ab-testing
* https://www.gov.uk/foreign-travel-advice (travel advice index page)
* https://www.gov.uk/find-local-council
* https://www.gov.uk/roadmap (GOV.UK public facing roadmap)

### Licence finders

Some examples:

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

Frontend is a Ruby on Rails application that renders the citizen-facing part of formats stored in the Content Store. It looks up the passed-in slug in the Content Store.

It also serves the homepage as a hard-coded route.

Calendar JSON data files are stored in `lib/data/<scope>.json`, with a `divisions` hash for separate data per region (`united-kingdom`, `england-and-wales`, `scotland` or `northern-ireland`).

Each scope's data file contains a list of divisions, containing a list of years, each with a list of events:

```json
{
  "title": "UK bank holidays",
  "description": "UK bank holidays calendar - see UK bank holidays and public holidays for 2012 and 2013",
  "divisions": {
    "england-and-wales": {
      "title": "England and Wales",
      "2011": [{
        "title": "New Year's Day",
        "date": "02/01/2011",
        "notes": "Substitute day"
      }]
    }
  }
}
```

The division `title` attribute is optional.  If this is not present the slug will be humanized and used instead.

### Dependencies

- [alphagov/static](https://github.com/alphagov/static) - provides shared templates, styles, and JavaScript
- [alphagov/content-store](https://github.com/alphagov/content-store) - provides raw data for rendering formats
- [alphagov/mapit](https://github.com/alphagov/mapit) - provides postcode lookups
- [alphagov/imminence](https://github.com/alphagov/imminence) - provides places lookups (e.g. for find-my-nearest)
- [alphagov/publishing-api](https://github.com/alphagov/publishing-api) - this app sends data to the content-store

### Running the application

If you are [using docker](https://github.com/alphagov/govuk-docker) to run the application (which is advised) it will be available on the host at http://frontend.dev.gov.uk/

To run the application standalone, run [static](https://github.com/alphagov/static) and execute the following command:

```
PLEK_SERVICE_STATIC_URI=http://127.0.0.1:3013 ./startup.sh --live
```

which uses a local copy of static and content from production.

Note that you will have to have [GOV.UK Mapit](https://github.com/alphagov/mapit) running locally. A valid dataset will have to be loaded for Mapit or postcode lookups will not succeed. This is part of the standard GOV.UK data replication steps.

To run in a full development stack (with DNS, all apps running etc.) use`./startup.sh`.

### Running the test suite

`bundle exec rake` runs the test suite.

## Additional information for calendars

Send the calendars to the publishing-api:

    bundle exec rake publishing_api:publish_calendars

If you're using govuk-docker, you may need to `govuk-docker-up` on `publishing-api` in a separate shell. You may also need to run the rake task a couple of times if you encounter timeouts.

Search indexing is performed automatically on data sent to publishing api.

A rake task has been created to generate the bank holidays JSON for a given year. They need to be then inserted, and modified to take into account any additions/modifications made by proclamation.

Run the rake task like this:

    bundle exec rake bank_holidays:generate_json[2016]

### Canonical sources

- For summer time, we can use the [Summer Time Act 1972](http://www.legislation.gov.uk/ukpga/1972/6).

- Bank holidays are determined both by law and by proclamation. We use the following legislation: the [Banking and Financial Dealings Act 1971](http://www.legislation.gov.uk/ukpga/1971/80/schedule/1)
and the [St Andrew's Day Bank Holiday Act](http://www.legislation.gov.uk/asp/2007/2/section/1).

- The proclamations of holidays are published in [The Gazette](https://www.thegazette.co.uk/all-notices/notice?noticetypes=1101&sort-by=latest-date&text="Banking+and+Financial").
Holidays are announced there 6 months to one year in advance, usually between the months of May and July for the following year.

## Licence

[MIT Licence](LICENCE.txt)
