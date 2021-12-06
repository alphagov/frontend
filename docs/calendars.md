# Calendars

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

## Publishing Calendars

You'll need to run the `publishing_api:publish_calendars` rake task against the `frontend` app on the `frontend` machine.

This will update <https://www.gov.uk/when-do-the-clocks-change> and <https://www.gov.uk/bank-holidays>.

To test locally, you may need to `govuk-docker-up` on `publishing-api` in a separate shell, before you run the rake task. You may also need to run the rake task a couple of times if you encounter timeouts.

## Bank Holidays

A rake task has been created to generate the bank holidays JSON for a given year. They need to be then inserted, and modified to take into account any additions/modifications made by proclamation.

Run the rake task like this:

    bundle exec rake bank_holidays:generate_json[2016]

### Canonical sources

- For summer time, we can use the [Summer Time Act 1972](http://www.legislation.gov.uk/ukpga/1972/6).

- Bank holidays are determined both by law and by proclamation. We use the following legislation: the [Banking and Financial Dealings Act 1971](http://www.legislation.gov.uk/ukpga/1971/80/schedule/1)
and the [St Andrew's Day Bank Holiday Act](http://www.legislation.gov.uk/asp/2007/2/section/1).

- The proclamations of holidays are published in [The Gazette](https://www.thegazette.co.uk/all-notices/notice?noticetypes=1101&sort-by=latest-date&text="Banking+and+Financial").
Holidays are announced there 6 months to one year in advance, usually between the months of May and July for the following year.
