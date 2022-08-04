# Elections API

The [Contact Electoral Registration Office](https://www.gov.uk/contact-electoral-registration-office)
page is published as a Local Transaction format page. These usually do postcode
lookups via Locations API and then get council and URL information from Local Links
Manager.

Electoral Commission have [a public API](https://api.electoralcommission.org.uk/)
for finding this information which they keep up to date.

The API is also capable of disambiguating postcodes that span local authority
boundaries.

The API contains other information, such as dates and times of elections and where
your local polling station is, however we're not using that yet.

## Reverting to the local transaction

Should we need to revert to not using the API, we just need to comment out or
remove the line in `routes.rb` that sends requests to `electoral_controller`.

The content item is still a local transaction, so the standard routing will kick
in further down.

## Contact

Electoral Commission's public contact details are:

 - phone: 0333 103 1928
 - web: https://www.electoralcommission.org.uk/contact-us

The API is currently supported by Democracy Club, so another good place to ask for
help is the [Democracy Club Slack](https://democracyclub.slack.com)

## Development

To interact with the API locally, create a .env file in the root of this project
with the following entries:

```
ELECTIONS_API_URL=<get value from integration secrets>
ELECTIONS_API_KEY=<get value from integration secrets>
```

[The API has its own documentation](https://api.electoralcommission.org.uk/docs/).

## Application flows

### Unambiguous postcode

Land on https://www.gov.uk/contact-electoral-registration-office

Enter unambiguous postcode (eg W1A 1AA)

Click "Find"

See results on https://www.gov.uk/contact-electoral-registration-office?postcode=w1a+1aa

### Ambiguous postcode

Land on https://www.gov.uk/contact-electoral-registration-office

Enter ambiguous postcode (eg WV14 8TU)

Click "Find"

See address picker on https://www.gov.uk/contact-electoral-registration-office??postcode=WV14+8TU

Select an address and click "Continue"

See results on https://www.gov.uk/contact-electoral-registration-office?uprn=10008768298

### Postcode with no location

Land on https://www.gov.uk/contact-electoral-registration-office

Enter "valid" postcode that doesn't exist in a local authority (eg XM45 HQ)

Click "Find"

See "We couldn't find this postcode" error on https://www.gov.uk/contact-electoral-registration-office?postcode=xm45hq

### Invalid postcode

Land on https://www.gov.uk/contact-electoral-registration-office

Enter invalid postcode (eg Bernard)

Click "Find"

See "This isn't a valid postcode" error on https://www.gov.uk/contact-electoral-registration-office?postcode=Bernard

### Invalid UPRN

Navigate to an invalid UPRN somehow: https://www.gov.uk/contact-electoral-registration-office?uprn=HELLO

See "This isn't a valid address" error on https://www.gov.uk/contact-electoral-registration-office?uprn=HELLO
