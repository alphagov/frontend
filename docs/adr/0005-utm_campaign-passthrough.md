# utm_campaign Passthrough

Date: 2026-08-06

## Context
It's mandatory for the first page of a service to be a service start page on GOV.UK. So, for instance, the end of one service cannot link directly to another. An example is adding a link to the register to vote service on the final page of the DVLA renew your driving license service. That link must go to the service start page on GOV.UK.

This means that service providers are not able to track referrals from one service to another, as they all come through GOV.UK, removing referral information.

### Option 1
GOV.UK reads the referer header and interprets this before passing it on to the receiving service.

#### Pros
+ Doesn't require the initiating service to make any change.
+ No privacy issues as data is only suitable for aggregate use

#### Cons
- Referer headers are often masked by browsers
- Would require update of bespoke code every time a new referer needed to be detected
- Tricky to differentiate between (say) A/B versions of the referring page - they'd have the same referral location.

### Option 2
Allow service start pages to pass through a custom parameter.

#### Pros
+ Allows refering service to add different values to the parameter for A/B testing
+ More stable than referer

#### Cons
- Requires agreement on the referring site to not pass PII
- Refering service has to add the parameter.

### Option 3
As option 2, but parameter is `utm_campaign`, ie the campaign parameter used by GA4.

#### Pros
+ As Option 2, plus immediately usable for GA4

#### Cons
- As Option 2

## Decision
Option 3 - this is likely to be most useful, and the `utm_campaign` parameter allows existing GA4 analytics tools to work without any changes. As long as the flag contains no PII and is used for aggregate data it doesn't present a privacy issue. We need to stress to services using this that the passed-through value should be subject to their normal consent controls (ie if the user has opted out of aggregate data collection on the receiving service, the parameter value should not be stored).

## Contributors

- @kludgekml
- @Nyz
- Paul Cronk

## Status
Accepted

## Consequences
We will allow `transaction` elements to pass through the value of the `utm_campaign` query parameter (if present) to the service start button.

## Related Links

- https://gds.slack.com/archives/C06E0JUDMUZ/p1785158971870609
- https://govuk.zendesk.com/agent/tickets/6693161
