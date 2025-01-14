# Calendars

Calendar JSON data files are stored in `lib/data/<type>.json`, with a `divisions` hash for separate data per region (`united-kingdom`, `england-and-wales`, `scotland` or `northern-ireland`).

Each type's data file contains a list of divisions, containing a list of years, each with a list of events:

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
