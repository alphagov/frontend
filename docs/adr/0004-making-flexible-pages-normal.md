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

