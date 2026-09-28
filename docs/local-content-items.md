# Local Content Items

For local development and preview apps, it is sometimes desirable to have the ability to load content items that are specified locally rather than pointing to production/integration or having the content store running locally.

To support this the following option must be set in your environment (currently done already in `startup.sh`)

`ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE=true`

With that environment variable set, the ContentItemLoader will add an additional check when loading a content item from the content store. Before making the GdsApi content store call, it will look in `lib/data/local-content-items/` for a JSON file matching the path of the content item.

For example, if you're looking for `/find-licences/my-licence`, it will look for `lib/data/local-content-items/find-licences/my-licence.json`

Your file should be valid JSON for a content item (you can get one from the content api and modify it)

## Using Publishing API examples

If you have publishing-api checked out in a parallel directory (for example both under `~/govuk/`), you can also load content items directly from the publishing-api [content schema examples](https://github.com/alphagov/publishing-api/tree/main/content_schemas/examples) (the same ones we use for test suites). Currently this will only work for schemas that are recognised via a FullPathFormatRoutingConstraint, because the paths will not look like valid paths. This currently includes:

- detailed_guide
- html_publication
- manual
- manual_section
- publication
- specialist_document
- gone

To load one of these items, append the path _after_ `examples`, but without the `.json` suffix.

For example, to view the detailed guide example [best-practice-detailed-guide.json](https://github.com/alphagov/publishing-api/blob/main/content_schemas/examples/detailed_guide/frontend/best-practice-detailed-guide.json), visit `http://frontend.dev.gov.uk/detailed_guide/frontend/best-practice-detailed-guide)

Note that publishing-api is not a gem included in the app, so this will not work on integration or preview apps, even if they have the `ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE` variable set. If you need to use a schema example in a preview app, copy it into the `lib/data/local-content-items/` directory with an appropriate path (one advantage of this is that you're not limited to FullPathRoutingConstraint routes, because you can craft the route fully)
