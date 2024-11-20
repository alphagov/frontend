# Local Content Items

For local development and preview apps, it is sometimes desirable to have the ability to load content items that are specified locally rather than pointing to production/integration or having the content store running locally.

To support this, set:

`ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE=true`

...in your environment.

With that environment variable set, the ContentItemLoader will add an additional check when loading a content item from the content store. Before making the GdsApi content store call, it will look in config/local-content-items/ for a JSON or YAML file matching the path of the content item (for instance, if you're looking for /find-licences/my-licence, it will look for config/local-content-items/find-licences/my-licence.json, then config/local-content-items/find-licences/my-licence.yml)
