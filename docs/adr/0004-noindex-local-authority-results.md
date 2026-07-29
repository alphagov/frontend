# NOINDEX Local Authority Results

Date: 2026-07-29

## Context
Local Transactions, license transactions with local authority results, and related local authority lookups consist of a search page, an optional address picker page (if a postcode is not enough to narrow down to an authority), and a final local authority results page. These pages are sometimes (but not always) allowed to be indexed in search engines.

Unfortunately, recent changes to search engines have resulted in general searches (eg local council bins) returning specific results (eg the bin collection day link page for a specific council), which leads to users entering at the wrong page and being confused by the results.

Example: [This google search](https://www.google.com/search?q=premises+licence+change+of+address) at the time of writing the ADR returns GOV.UK as the third result, and the description and link shown in google imply that it's a general page for England and Wales, but in fact it's the specific page for East Hampshire.


### Option 1
Remove local authority results pages from search indexes. This would make sure they did not appear in search results from search engines.

#### Pros
+ Relatively simple fix
+ Improves results closer to the start of the process, hopefully in the search engine.

#### Cons
- Changes behaviour, we don't necessarily know if the indexed pages are used in other ways.

### Option 2
Make council name more prominent on the licence pages, perhaps with a link to the main page to switch to another council - though users still might not notice it, as we've seen in similar cases such as the Withdrawn boxes

#### Pros
+ Content fix, doesn't change existing behaviour
+ Simple for devs

#### Cons
- Users still might not notice the council name, as we've seen in similar cases such as the Withdrawn boxes
- Leaves search results in Google, which means users could still end up at the wrong place

## Decision
Option 1 - we will add NOINDEX tags to the results pages for local authority postcode searches so that they will not be indexed by search engines, ensuring that the search results for generic searches point to the lookup page.

## Contributors

- @kludgekml
- @sihugh
- @tarastockford

## Status
Implemented as of [PR #5703](https://github.com/alphagov/frontend/pull/5703)

## Consequences
We will add NOINDEX tags to local authority result pages in /find-local-council route, licence transaction routes, local transaction routes, and /contact-electoral-registration-office route. The search pages will
remain indexable, but results pages (and interstitial address choosing pages) will not.
