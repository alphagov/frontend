# Local Authorities API

NB: The api version of the /find-local-council page is provided for the use of the App, and any other use should take
that into consideration. The information in this api is public, since there's no more information than on
/find-local-council, but it is not currently versioned, may change without notice, and is likely to be rate limited.

## Endpoints

### GET /api/local-authority?postcode=<POSTCODE>

For the supplied postcode, attempts to find the local authority (or authorities) that postcode is covered by.

Returns

- 301 and redirects to a local authority record if the postcode is entirely within that authority (see the endpoint below)
- 200 and an array of address records if the postcode spans multiple authorities
- 400 and an error message if no postcode parameter found or the parameter is empty
- 400 and an error message if the postcode is an invalid format for postcodes
- 404 and an error message if the postcode is valid, but no records are found for it

Address record arrays will look like this:

```
{
  "addresses": [
    { "address": "House 1", "slug": "achester", "name": "Achester" },
    { "address": "House 2", "slug": "beechester", "name": "Beechester" },
    { "address": "House 3", "slug": "ceechester", "name": "Ceechester" },
  ],
}
```

The address will be the full street address to display for the user to choose, the slug can then be used to build the url
for the authority endpoint (see below)

### GET /api/local-authority/<authority-slug>

Resolves the supplied slug into a local authority record.

Returns

- 200 and a local authority record if the authority slug is found
- 404 and an error message if the authority slug is not found

Authority records will look like this:

...for a unitary body:

```
{
  "local_authority": {
    "name": "Westminster",
    "homepage_url": "http://westminster.example.com",
    "tier": "unitary",
    "slug": "westminster"
  }
}
```

...for a two-tier body (where the slug is the district):
```
{
  "local_authority": {
    "name": "Aylesbury",
    "homepage_url": "http://aylesbury.example.com",
    "tier": "district",
    "slug": "aylesbury",
    "parent": {
      "name": "Buckinghamshire",
      "homepage_url": "http://buckinghamshire.example.com",
      "tier": "county",
      "slug": "buckinghamshire",
    },
  }
}
```

...for a two-tier body (where the slug is the county):
```
{
  "local_authority": {
    "name": "Buckinghamshire",
    "homepage_url": "http://buckinghamshire.example.com",
    "tier": "county",
    "slug": "buckinghamshire"
  }
}
```

Note that at the moment the authority records never contain children, only parents. The postcode query endpoint will
always return the smallest authority it matches, so it will never redirect to a county in a two-tier system, only to
a district (with a parent record), or a unitary body. The only way you can get a two-tier county record by itself is
directly calling the endpoint.
