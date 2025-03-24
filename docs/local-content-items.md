# Local Content Items

For local development and preview apps, it is sometimes desirable to have the ability to load content items that are specified locally rather than pointing to production/integration or having the content store running locally.

To support this the following option must be set in your environment (currently done already in `startup.sh`)

`ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE=true`

With that environment variable set, the ContentItemLoader will add an additional check when loading a content item from the content store. Before making the GdsApi content store call, it will look in `lib/data/local-content-items/` for a JSON or YAML file matching the path of the content item.

For example, if you're looking for `/find-licences/my-licence`, it will look for `lib/data/local-content-items/find-licences/my-licence.json`, then `lib/data/local-content-items/find-licences/my-licence.yml`.

Your file should have this basic structure:

```
schema_name: landing_page
document_type: landing_page
base_path: test
details:
  blocks:
  - type: two_column_layout
    theme: two_thirds_one_third
    blocks:
    - type: govspeak
      content: this is a string designed to be long enough to fill an entire row so that the words wrap around onto the next line like this
```
