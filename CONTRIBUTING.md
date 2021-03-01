## Git workflow ##

- Pull requests must contain a succinct, clear summary of what the user need is driving this feature change.
- Follow our [Git styleguide](https://github.com/alphagov/styleguides/blob/master/git.md)
- Make a feature branch
- Ensure your branch contains logical atomic commits before sending a pull request - follow our [Git styleguide](https://github.com/alphagov/styleguides/blob/master/git.md)
- Pull requests are automatically integration tested, where applicable using [Travis CI](https://travis-ci.org/), which will report back on whether the tests still pass on your branch
- You *may* rebase your branch after feedback if it's to include relevant updates from the master branch. We prefer a rebase here to a merge commit as we prefer a clean and straight history on master with discrete merge commits for features

## Copy ##

- Follow the [style guide](https://www.gov.uk/designprinciples/styleguide)
- URLs should use hyphens, not underscores

## Code ##

- Must be readable with meaningful naming, eg no short hand single character variable names
- Follow our [Ruby style guide](https://github.com/alphagov/styleguides/blob/master/ruby.md)

## Testing ##

Write tests.

### Pact tests

If you make changes to the Bank Holidays API, you'll need to update the Pact tests.

To test your changes locally, you can specify a Pact broker URI, can point to a local pactfile on disk:

```sh
govuk-docker-run env PACT_URI="../gds-api-adapters/spec/pacts/gds_api_adapters-bank_holidays_api.json" bundle exec rake pact:verify 
```
