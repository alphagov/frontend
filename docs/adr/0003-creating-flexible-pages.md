# Creating Flexible Pages

Date: 2026-05-18

## Context
The flexible content project has moved away from the concept of a totally flexible content type in favour of improving convenience in creating new document types in Whitehall. This means that our assumption that we will mostly be getting an array of flexible sections in a content type is invalid. Content types will remain rigid, containing semantically named properties of the page.

This leaves us with some code built on a faulty assumption, which we have worked around by page models that translate the rigid content item into a flexible sections hash, which is then parsed in the same way the `plan_for_change_landing_page` content items are parsed. This is undesirable because it adds another layer of abstraction and is confusing for new developers. It also leaves us with a situation in which flexible sections are sometimes tied too closely to their pages.

### Option 1
Do nothing - leave flexible content creation as close as possible to how `plan_for_change_landing_page`s are specified.

#### Pros
+ No action needed
+ Leaves the door open for truly flexible content types in future

#### Cons
- As above, confusing page models
- Drifting understanding of what a flexible content item is between publishing and rendering
- Codifies an incorrect assumption

### Option 2
Handle flexible pages as we do existing content items

#### Pros
+ Keeps consistency with older content types
+ Simple for devs

#### Cons
- Requires changing the existing pages
- Risk of drift between how the pages handle various things as new types added - as is a known problem with existing page types.

### Option 3
Create flexible sections directly in initializer of the various flexible pages,
simplify data passed to flexible sections by converting in the page model (with helpers if multiple page models have to do the same conversions).

#### Pros
+ Simple for devs
+ Allows us greater flexibility in putting pages together (for instance can use nested types, which we avoided because we didn't want editors using them)
+ Makes Flexible Sections more like mega-components, self-contained things that we can instantiate in the component guide for better documentation
+ Self-contained Flexible Sections can be used in non-flexible pages, aiding us in moving towards a more unified look for GOV.UK pages.

#### Cons
- Models become partly presentational (potentially move the section creation into
  a presenter later?)
- Needs a big PR for changes.

## Decision
Option 3

## Status
Accepted

## Consequences
We will move away from the flexible-hash method of flexible section instantiation towards a more self-contained and idiomatic way of creating flexible sections in flexible page models.
