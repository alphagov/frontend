# Turning flexible pages into normal ones

Date: 2026-09-22

## Context
As mentioned in [ADR-0003](/docs/adr/0003-creating-flexible-pages.md), the flexible content project has moved away from the concept of a totally flexible content type in favour of improving convenience in creating new document types in Whitehall, and overall systemic flexibility. There has been a small move back towards arrays of content sections with [RFC-197](https://www.github.com/alphagov/govuk-rfcs/pull/197), but it's smaller in scope.

At the same time, we've been leaning into the standardisation afforded us by the app consolidation programme, making other document types more similar. Having flexible pages as an odd outlier where layout occurs in a model means that we are running two separate idioms for rendering content items (actually more, because of pages with parts, but those are out of scope for this decision).

### Option 1
Do nothing - leave flexible content creation in initializer of the various flexible pages.

#### Pros
+ Makes Flexible Sections more like mega-components, self-contained things that we can instantiate in the component guide for better documentation
+ No action required

#### Cons
- Models remain partly presentational, causing problems with onboarding
- We retain a concept that is looking increasingly unnecessary
- Less idiomatic Rails

### Option 2
Remove the concept of flexible pages as a thing in Frontend, reverting the existing Flexible Page to a more normal type of document rendering (separate Controller/Model/Presenter/View)

#### Pros
+ Removes a concept, simplifying dev work
+ More idiomatic Rails

#### Cons
- Needs a big PR for changes

## Decision
Option 2

## Status
Accepted

## Consequences
We will move away from the Flexible Page model entirely, moving the last Flexible Page (Topical Events) to a more standard Controller/Model/Presenter/View model and bringing it in line with the other routes.
