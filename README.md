# Frontend

Frontend renders the citizen-facing part of content items stored in the Content Store, and
some hard-coded routes.

## Formats

| Format | Schema/Document Type | Live example(s) |
|---|---|---|
|AB testing             |hardcoded|https://www.gov.uk/help/ab-testing|
|Answer                 |[answer](https://docs.publishing.service.gov.uk/content-schemas/answer.html)|https://www.gov.uk/national-minimum-wage-rates|
|Asset placeholder      |hardcoded|https://assets.publishing.service.gov.uk/government/placeholder|
|Calendars              |[calendar](https://docs.publishing.service.gov.uk/content-schemas/calendar.html)|https://www.gov.uk/bank-holidays|
|                       ||https://www.gov.uk/when-do-the-clocks-change|
|Call for evidence   |schema: [call_for_evidence](https://docs.publishing.service.gov.uk/content-schemas/call_for_evidence.html)|https://www.gov.uk/government/calls-for-evidence/credit-union-common-bond-reform|
|                       ||https://www.gov.uk/government/calls-for-evidence/safety-of-journalists-call-for-evidence|
|                       ||https://www.gov.uk/government/calls-for-evidence/review-of-civil-legal-aid-call-for-evidence|
|Case studies           |[case_study](https://docs.publishing.service.gov.uk/content-schemas/case_study.html)|https://www.gov.uk/government/case-studies/aiding-capability-decision-making-for-the-royal-navy|
|Consultation           |[consultation](https://docs.publishing.service.gov.uk/content-schemas/consultation.html)|https://www.gov.uk/government/consultations/soft-drinks-industry-levy|
|Cookies                |hardcoded|https://www.gov.uk/help/cookies|
|Corporate information pages  |[corporate_information_page](https://docs.publishing.service.gov.uk/content-schemas/corporate_information_page.html)|https://www.gov.uk/government/organisations/forensic-science-regulator/about|
|                             |                                   |https://www.gov.uk/government/organisations/forensic-science-regulator/about/accessible-documents-policy|
|Detailed Guide        |[detailed_guide](https://docs.publishing.service.gov.uk/content-schemas/detailed_guide.html)|https://www.gov.uk/guidance/selling-second-hand-vehicles-using-a-vat-margin-scheme|
|Document collection    |[document_collection](https://docs.publishing.service.gov.uk/content-schemas/document_collection.html)|https://www.gov.uk/government/collections/statutory-guidance-schools|
|Fatality notice        |[fatality_notice](https://docs.publishing.service.gov.uk/content-schemas/fatality_notice.html)|https://www.gov.uk/government/fatalities/corporal-lee-churcher-dies-in-iraq|
|Field of operation     |[field_of_operation](https://docs.publishing.service.gov.uk/document-types/field_of_operation.html)|https://www.gov.uk/government/fields-of-operation/united-kingdom|
|Fields of operation    |[fields_of_operation](https://docs.publishing.service.gov.uk/content-schemas/fields_of_operation.html)|https://www.gov.uk/government/fields-of-operation|
|Find electoral office  |hardcoded|https://www.gov.uk/contact-electoral-registration-office|
|Find local council     |hardcoded|https://www.gov.uk/find-local-council|
|Foreign travel advice index |[travel_advice_index](https://docs.publishing.service.gov.uk/content-schemas/travel_advice_index.html)|https://www.gov.uk/foreign-travel-advice|
|Foreign travel advice  |[travel_advice](https://docs.publishing.service.gov.uk/content-schemas/travel_advice.html)|https://www.gov.uk/foreign-travel-advice/azerbaijan|
|Guide                  |[guide](https://docs.publishing.service.gov.uk/content-schemas/guide.html)|https://www.gov.uk/log-in-register-hmrc-online-services|
|Help index             |hardcoded|https://www.gov.uk/help|
|Help                   |[help_page](https://docs.publishing.service.gov.uk/content-schemas/help_page.html)|https://www.gov.uk/help/browsers|
|History                |[history](https://docs.publishing.service.gov.uk/content-schemas/history.html)|https://www.gov.uk/government/history/10-downing-street|
|Homepage               |[homepage](https://docs.publishing.service.gov.uk/content-schemas/homepage.html)|https://www.gov.uk/|
|How Government Works   |[how_government_works](https://docs.publishing.service.gov.uk/content-schemas/how_government_works.html)|https://www.gov.uk/government/how-government-works|
|HTML Publication       |[html_publication](https://docs.publishing.service.gov.uk/content-schemas/html_publication.html)|https://www.gov.uk/government/publications/car-show-me-tell-me-vehicle-safety-questions/car-show-me-tell-me-vehicle-safety-questions|
|                       ||https://www.gov.uk/government/publications/skilled-worker-visa-temporary-shortage-list/skilled-worker-visa-temporary-shortage-list|
|                       ||https://www.gov.uk/government/publications/usa-apply-for-a-uk-visa/apply-for-a-uk-visa-in-the-usa|
|Get involved           |[get_involved](https://docs.publishing.service.gov.uk/content-schemas/get_involved.html)|https://www.gov.uk/government/get-involved|
|Gone                   |[gone](https://docs.publishing.service.gov.uk/content-schemas/gone.html)|https://www.gov.uk/government/collections/greenhouse-gas-conversion-factors-for-company-reporting|
|Licence finder         |schema: [specialist_document](https://docs.publishing.service.gov.uk/content-schemas/specialist_document.html)|https://www.gov.uk/find-licences/premises-licence|
|                       |document_type: [licence_transaction](https://docs.publishing.service.gov.uk/document-types/licence_transaction.html)|https://www.gov.uk/find-licences/zoo-licence|
|Local transaction      |[local_transaction](https://docs.publishing.service.gov.uk/content-schemas/specialist_document.html)|http://www.gov.uk/school-term-holiday-dates|
|                       ||http://www.gov.uk/apply-council-tax-reduction|
|Manual Section         |[manual_section](https://docs.publishing.service.gov.uk/content-schemas/manual_section.html)|http://www.gov.uk/guidance/systems-change-learning/1-securing-strategic-buy-in-and-alignment
|News Article           |[news_article](https://docs.publishing.service.gov.uk/content-schemas/news_article.html)|https://www.gov.uk/government/news/the-personal-independence-payment-amendment-regulations-2017-statement-by-paul-gray|
|Place                  |[place](https://docs.publishing.service.gov.uk/content-schemas/place.html)|http://www.gov.uk/register-offices|
|                       ||http://www.gov.uk/register-offices|
|Publication            |[publication](https://docs.publishing.service.gov.uk/content-schemas/publication.html)|https://www.gov.uk/government/publications/budget-2016-documents|
|Roadmap                |hardcoded|https://www.gov.uk/roadmap|
|Service Manual guide|[service_manual_guide](https://docs.publishing.service.gov.uk/content-schemas/service_manual_guide.html)|https://www.gov.uk/service-manual/agile-delivery/how-the-discovery-phase-works|
|Service Manual homepage|[service_manual_homepage](https://docs.publishing.service.gov.uk/content-schemas/service_manual_homepage.html)|https://www.gov.uk/service-manual|
|Service Manual service standard page|[service_manual_service_standard](https://docs.publishing.service.gov.uk/content-schemas/service_manual_service_standard.html)|https://www.gov.uk/service-manual/service-standard|
|Service Manual topic   |[service_manual_topic](https://docs.publishing.service.gov.uk/content-schemas/service_manual_topic.html)|https://www.gov.uk/service-manual/agile-delivery|
|                       ||https://www.gov.uk/service-manual/user-research|
|                       ||https://www.gov.uk/service-manual/helping-people-to-use-your-service|
|Service toolkit page   |[service_toolkit_page](https://docs.publishing.service.gov.uk/content-schemas/service_manual_service_toolkit.html)|https://www.gov.uk/service-toolkit|
|Simple smart answer    |[simple_smart_answer](https://docs.publishing.service.gov.uk/content-schemas/simple_smart_answer.html)|https://www.gov.uk/sold-bought-vehicle|
|                       ||https://www.gov.uk/contact-the-dvla|
|Specialist Document    |schema: [specialist_document](https://docs.publishing.service.gov.uk/content-schemas/specialist_document.html)|https://www.gov.uk/cma-cases/veterinary-services-market-for-pets-review|
|                       ||https://www.gov.uk/aaib-reports/aaib-investigation-to-aw189-g-fsar|
|                       ||https://www.gov.uk/protected-food-drink-names/pitahaya-amazonica-de-palora|
|Speech                 |[speech](https://docs.publishing.service.gov.uk/content-schemas/speech.html)|https://www.gov.uk/government/speeches/motorcycle-testing|
|Statistical Data Set   |[statistical_data_set](https://docs.publishing.service.gov.uk/content-schemas/statistical_data_set.html)|https://www.gov.uk/government/statistical-data-sets/local-government-pension-scheme-funds-summary-data-2011-to-2012|
|Topical Event About Page|[topical_event_about_page](https://docs.publishing.service.gov.uk/content-schemas/topical_event_about_page.html)|https://www.gov.uk/government/topical-events/western-balkans-summit-london-2018/about|
|Transaction start page |[transaction](https://docs.publishing.service.gov.uk/content-schemas/transaction.html)|https://www.gov.uk/register-to-vote|
|                       ||https://www.gov.uk/vehicle-tax|
|                       ||https://www.gov.uk/find-a-job|
| Working group         |[working_group](https://docs.publishing.service.gov.uk/content-schemas/working_group.html)|https://www.gov.uk/government/groups/abstraction-reform|
|Worldwide office page|[worldwide_office](https://docs.publishing.service.gov.uk/content-schemas/worldwide_office.html)|https://www.gov.uk/world/organisations/high-commission-victoria/office/british-high-commission-victoria|
|Worldwide organisation page|[worldwide_organisation](https://docs.publishing.service.gov.uk/content-schemas/worldwide_organisation.html)|https://www.gov.uk/world/organisations/high-commission-victoria|

## Nomenclature

- **format**: our phrase for a type of content

## Technical documentation

Frontend is a Ruby on Rails application and should follow [our Rails app conventions](https://docs.publishing.service.gov.uk/manual/conventions-for-rails-applications.html).

See the [CONTRIBUTING](CONTRIBUTING.md) guide for more information.

### Dependencies

- [alphagov/content-store](https://github.com/alphagov/content-store) - provides raw data for rendering formats
- [alphagov/local-links-manager](https://github.com/alphagov/local-links-manager) - provides council info lookups
- [alphagov/locations-api](https://github.com/alphagov/locations-api) - provides postcode lookups
- [alphagov/places-manager](https://github.com/alphagov/places-manager) - provides places lookups (e.g. for find-my-nearest)
- [alphagov/publishing-api](https://github.com/alphagov/publishing-api) - this app sends data to the content-store

### Running the application

You can use the [GOV.UK Docker environment](https://github.com/alphagov/govuk-docker) or the local `startup.sh` script to run the app. Read the [guidance on local frontend development](https://docs.publishing.service.gov.uk/manual/local-frontend-development.html) to find out more about each approach, before you get started.

If you are using GOV.UK Docker, remember to combine it with the commands that follow. See the [GOV.UK Docker usage instructions](https://github.com/alphagov/govuk-docker#usage) for examples.

If you are using the `startup.sh` script, execute the following command:

```
./startup.sh --live
```

which uses content from production.

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
