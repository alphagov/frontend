# Calendars

## Bank Holidays

The calendar data is in `lib/data/bank-holidays.json`, with a `divisions` hash for separate data per region (`united-kingdom`, `england-and-wales`, `scotland` or `northern-ireland`).

Each type's data file contains a list of divisions, containing a list of years, each with a list of events:

```json
{
  "title": "bank_holidays.calendar.title",
  "description": "bank_holidays.calendar.description",
  "divisions": {
    "england-and-wales": {
      "title": "common.nations.england-and-wales_slug",
      "2011": [{
        "title": "bank_holidays.new_year",
        "date": "02/01/2011",
        "notes": ""
      }]
    }
  }
}
```

The strings are all localisation paths, which allows the calendar to be available in English at [/bank-holidays](https://www.gov.uk/bank-holidays) and in Welsh at [/gwyliau-banc](https://www.gov.uk/gwyliau-banc).

## When do the clocks change

The calendar data is in `lib/data/when-do-the-clocks-change.json`. Since the clocks change in all four regions at
the same time, there is only one common division. As with the bank holiday data, all strings are localisation paths (although at the moment this data exists only for english).

## Publishing Calendars

These two calendars are special routes, published using `rails special_routes:publish` in `publishing-api`.

Note that the routes do not need to be republished when data in the JSON file is changed - only if the routes are missing from content-store, or if the rendering app changes.
