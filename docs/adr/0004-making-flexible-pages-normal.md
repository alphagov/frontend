# Making Flexible Pages Normal

Following ADR 0003, Flexible pages have become easier to work with. However, there are still issues with the concept.

- Flexible sections get added in a model - but aren't they presentational?
- Flexible sections are quite like components, indeed some effectively _are_ components, because they're just wrappers around them. But others are different enough that they can't be easily represented in the component guide.
- How do flexible sections fall in the gap between components and shared partials?

## Pros of current (post ADR-0003) situation

- "Very easy to understand that PR" - it's easy for backenders to look at a flexible page model and see what's going into the page.
- There's some enforcement of rightness at build time which is harder to do with a more view-based approach
- Flexible sections being self contained makes it plausible (although we haven't done this) to use them _outside_ of flexible pages.

## Downsides of current situation

- Flexible pages are very different from other routes, and we deliberately moved away from a "single controller, with a different presenter and view for each page type" when we migrated from GF.
- It feels less idiomatic than "model -> presenter -> view" with the view holding the layout.
- Puts us in this weird situation where we don't have a good answer about what's a component, what's a section, what's just a shared partial.
- Makes it hard to just use components raw where it would be appropriate. Even the smallest component has to be wrapped in a flexible section to get it into the page.

## What we want to avoid

1. A reliance on bespoke work: One of the problems we were trying to avoid in Flexible Pages was doing a lot of bespoke work. Obviously the clearest way to provide ultimate flexibility is bespoke work, but as the PfC work showed, supporting both complete flexibility on the frontend and at the same time the existing structure of GOV.UK publishing (including drafts, scheduled publishing, 2i, etc), makes this very costly.

2. Too much "magic": Ideally as close to generic Ruby on Rails behaviour would be good, since it makes the code accessible and understandable to people outside the team and to new joiners.

3. Too many new concepts: Really there isn't a strong need for a specific category of flexible pages. All our pages are "a content item rendered as HTML"

## What we want to keep

1. Easy to understand: The current (as of this writing) code makes it nice and easy to see the structure of the flexible page. We should maintain this.

2. Easy to test: We've got a reasonable system now which encapsulates the tests for the flexible sections and means we can keep expensive system tests to a minimum.

3. Easy to limit: The current code makes it easy to restrict what we put in a page. We want to allow more things to be put in these pages, but we also want to make sure that the things we put in pages are known good.

## What we want to improve

1. More flexibility in what goes in the flexible pages: at the moment if we want a new component in a page, we have to wrap it in a flexible section, which just creates more work.

2. Ability to use flexible sections in other pages: it's a long-standing goal to reduce the amount of visual variance in gov.uk pages, and settling on flexible sections as a limited set of "arrangements" (so that we only have a handful of "top of page" styles for instance) seems promising.

## Options

### Make flexible pages more like all other pages

- Give each flexible page its own controller (or each set of related pages - TopicalEvent and TopicalEventAboutPage might reasonably share a controller, although we've tended to avoid sharing controllers unless there's a clear index/show type pattern)
- This lets us give each flexible page its own view, and instead of setting up the list of sections in the model, we should just lay them out in the view.
- Optional: We could add linting to make sure a view built in this way only included approved partials?
- Flexible sections to be audited and triaged into three groups: 1. "This is just a component wrapper", which we get rid of. 2. "This is a complex component that only makes sense if used as a whole", which we convert into app components. 3. "This is really a shared partial", which we move into the shared partials directory


