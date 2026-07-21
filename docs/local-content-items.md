# Local Content Items

For local development and preview apps, it is sometimes desirable to have the ability to load content items that are specified locally rather than pointing to production/integration or having the content store running locally.

To support this the following option must be set in your environment (currently done already in `startup.sh`)

`ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE=true`

With that environment variable set, the ContentItemLoader will add an additional check when loading a content item from the content store. Before making the GdsApi content store call, it will look in `lib/data/local-content-items/` for a JSON file matching the path of the content item.

For example, if you're looking for `/find-licences/my-licence`, it will look for `lib/data/local-content-items/find-licences/my-licence.json`

Your file should be valid JSON for a content item (you can get one from the content api and modify it)
