# Frontend

Frontend renders the citizen-facing part of content items stored in the Content Store, and
some hard-coded routes.

## Formats

| Format | Schema/Document Type | Live example(s) |
|---|---|---|
|AB testing             |hardcoded|https://www.gov.uk/help/ab-testing|
|Asset placeholder      |hardcoded|https://assets.publishing.service.gov.uk/government/placeholder|
|Calendars              |[calendar](https://docs.publishing.service.gov.uk/content-schemas/calendar.html)|https://www.gov.uk/bank-holidays|
|                       ||https://www.gov.uk/when-do-the-clocks-change|
|Case studies           |[case_study](https://docs.publishing.service.gov.uk/content-schemas/case_study.html)|https://www.gov.uk/government/case-studies/aiding-capability-decision-making-for-the-royal-navy|
|Cookies                |hardcoded|https://www.gov.uk/help/cookies|
|Fatality notice        |[fatality_notice](https://docs.publishing.service.gov.uk/content-schemas/fatality_notice.html)|https://www.gov.uk/government/fatalities/corporal-lee-churcher-dies-in-iraq|
|Find electoral office  |hardcoded|https://www.gov.uk/contact-electoral-registration-office|
|Find local council     |hardcoded|https://www.gov.uk/find-local-council|
|Foreign travel advice index |[travel_advice_index](https://docs.publishing.service.gov.uk/content-schemas/travel_advice_index.html)|https://www.gov.uk/foreign-travel-advice|
|Foreign travel advice  |[travel_advice](https://docs.publishing.service.gov.uk/content-schemas/travel_advice.html)|https://www.gov.uk/foreign-travel-advice/azerbaijan|
|Guidance               |[detailed_guide](https://docs.publishing.service.gov.uk/content-schemas/detailed_guide.html)|https://www.gov.uk/guidance/travel-to-england-from-another-country-during-coronavirus-covid-19|
|Help index             |hardcoded|https://www.gov.uk/help|
|Help                   |[help_page](https://docs.publishing.service.gov.uk/content-schemas/help_page.html)|https://www.gov.uk/help/browsers|
|Homepage               |[homepage](https://docs.publishing.service.gov.uk/content-schemas/homepage.html)|https://www.gov.uk/|
|Get involved           |[get_involved](https://docs.publishing.service.gov.uk/content-schemas/get_involved.html)|https://www.gov.uk/government/get-involved|
|Licence finder         |schema: [specialist_document](https://docs.publishing.service.gov.uk/content-schemas/specialist_document.html)|https://www.gov.uk/find-licences/premises-licence|
|                       |document_type: [licence_transaction](https://docs.publishing.service.gov.uk/document-types/licence_transaction.html)|https://www.gov.uk/find-licences/zoo-licence|
|Local transaction      |[local_transaction](https://docs.publishing.service.gov.uk/content-schemas/specialist_document.html)|http://www.gov.uk/school-term-holiday-dates|
|                       ||http://www.gov.uk/apply-council-tax-reduction|
|Place                  |[place](https://docs.publishing.service.gov.uk/content-schemas/place.html)|http://www.gov.uk/register-offices|
|                       ||http://www.gov.uk/register-offices|
|Roadmap                |hardcoded|https://www.gov.uk/roadmap
|Simple smart answer    |[simple_smart_answer](https://docs.publishing.service.gov.uk/content-schemas/simple_smart_answer.html)|https://www.gov.uk/sold-bought-vehicle|
|                       ||https://www.gov.uk/contact-the-dvla|
|Specialist Document    |https://www.gov.uk/cma-cases/veterinary-services-market-for-pets-review|
|                       |https://www.gov.uk/aaib-reports/aaib-investigation-to-aw189-g-fsar|
|                       |https://www.gov.uk/protected-food-drink-names/pitahaya-amazonica-de-palora|
|Speech                 |[speech](https://docs.publishing.service.gov.uk/content-schemas/speech.html)|https://www.gov.uk/government/speeches/motorcycle-testing|
|Take part              |[take_part](https://docs.publishing.service.gov.uk/content-schemas/take_part.html)|https://www.gov.uk/government/get-involved/take-part/improve-your-social-housing|
|Transaction start page |[transaction](https://docs.publishing.service.gov.uk/content-schemas/transaction.html)|https://www.gov.uk/register-to-vote|
|                       ||https://www.gov.uk/vehicle-tax|
|                       ||https://www.gov.uk/find-a-job|

## Nomenclature

- **format**: our phrase for a type of content

## Technical documentation

Frontend is a Ruby on Rails application and should follow [our Rails app conventions](https://docs.publishing.service.gov.uk/manual/conventions-for-rails-applications.html).

See the [CONTRIBUTING](CONTRIBUTING.md) guide for more information.

### Dependencies

- [alphagov/static](https://github.com/alphagov/static) - provides shared templates, styles, and JavaScript
- [alphagov/content-store](https://github.com/alphagov/content-store) - provides raw data for rendering formats
- [alphagov/local-links-manager](https://github.com/alphagov/local-links-manager) - provides council info lookups
- [alphagov/locations-api](https://github.com/alphagov/locations-api) - provides postcode lookups
- [alphagov/places-manager](https://github.com/alphagov/places-manager) - provides places lookups (e.g. for find-my-nearest)
- [alphagov/publishing-api](https://github.com/alphagov/publishing-api) - this app sends data to the content-store

### Running the application

You can use the [GOV.UK Docker environment](https://github.com/alphagov/govuk-docker) or the local `startup.sh` script to run the app. Read the [guidance on local frontend development](https://docs.publishing.service.gov.uk/manual/local-frontend-development.html) to find out more about each approach, before you get started.

If you are using GOV.UK Docker, remember to combine it with the commands that follow. See the [GOV.UK Docker usage instructions](https://github.com/alphagov/govuk-docker#usage) for examples.

If you are using the `startup.sh` script, first run [static](https://github.com/alphagov/static) and execute the following command:

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
