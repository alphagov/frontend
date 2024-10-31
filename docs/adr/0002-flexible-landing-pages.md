# Add Flexible Landing Page Support to Frontend

Date: 2024-10-01

## Context
Web group is sometimes asked to create entirely new landing-page-style pages for various initiatives,
and although often these are more appropriate as campaign sites, sometimes it does make sense to put
them on GOV.UK. This results in an awkward working process where either we have to put exceptions into
the rendering of an existing schema type, or hardcode a page or pages in one of the frontend apps.

It becomes even more complicated if the new pages are embargoed, so can't be developed in the open. We're then stuck with making the repo temporarily private, which is undesirable.

### Option 1
We modify rendering of existing schemas to deal with the requests.

#### Pros
+ No new schemas
+ Limited need for publishing app support

#### Cons
- Exceptions added in existing page types are brittle and lead to significant tech debt
- Most existing schemas can only be modified so far

### Option 2
Hardcode pages into Frontend as necessary

#### Pros
+ Quickest in the short term

#### Cons
- Doing this time and again will quickly add up
- Codebase increases in size with every new page
- No ability to do this for embargoed data
- Even the smallest content change will require developer support
- Hardcoded pages can't get into the search engine easily

### Option 3
New schema: "landing_page", whose content is a nested tree of blocks which loosely
map to component-like partials. This allows the layout of the page to be specified
in the content item and rendered in frontend. The content item can be edited in
Whitehall and published in the normal manner.

#### Pros
+ Very flexible, can render pages with very different layouts
+ Might be able to replace some existing hard-coded pages (eg history pages, topical pages)
+ Whitehall support for the schema allows development of embargoed content without
  having to make the repo private.
+ Developer support needed initially, but as support improves in Whitehall that
  need will reduce.

#### Cons
- Initial work to do this quite involved
- Requires publishing support

## Decision
Option 3

## Status
Accepted

## Consequences
We will add support for the landing_page schema in frontend, and adding it as
an editionable item in Whitehall.
