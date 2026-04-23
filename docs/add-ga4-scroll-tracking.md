# Adding GA4 scroll tracking

If you need to add GA4 scroll tracking to a route, follow these steps:

1. Navigate to `app/helpers/application_helper.rb`
2. Add the base path to the `PERCENTAGE_SCROLL_TRACKING_URLS` array
3. Scroll tracking should now appear on that base path

For example:

```
  PERCENTAGE_SCROLL_TRACKING_URLS = [
    "/guidance/assessing-sites-for-local-plans-stage-2",
    "/guidance/confirming-draft-allocations-and-recording-decisions-for-local-plans-stage-4",
    "/guidance/determining-your-draft-allocations-for-local-plans-stage-3",
  ].freeze
```