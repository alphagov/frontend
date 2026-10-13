# Percy tests

Percy tests take screenshots of specific pages, comparing them with previous screenshots of the same pages. If any visual changes are detected, the code owners (which can be found [here](https://docs.publishing.service.gov.uk/repos/frontend.html)) will be notified on Slack. The goal of this is to reduce blind spots in our test process, as sometimes pages have complex requirements or unique quirks that break when a component or layout is updated. These can be hard to spot in PRs or in the components gem due to the volume of pages on GOV.UK.

Pages can be added by modifying `spec/visual_regression_tests/test_pages_spec.rb`.

When a page is added to the test list, it will add around 60 screenshots to our monthly usage limit. This is because Percy will take a daily screenshot of a desktop and mobile version of the page. We have a fairly large usage limit, but it's worth double checking before adding pages: https://dashboard.percy.io/usage?org=9d94781c

## Running Percy tests locally

1. Firstly, you'll need to download ZScaler's certificate to your machine. Store it in a directory such as `~/certs/zscaler-root-ca.pem` https://github.com/alphagov/govuk-infrastructure/blob/main/cacerts/zscaler-root-ca.pem
2. [Login to Percy](https://dashboard.percy.io/web/projects/frontend-2026-5462b35e/settings?org=9d94781c) and grab the secret token. Run `export PERCY_TOKEN=[token]` locally, replacing `[token]` with the secret.
3. Disable simplecov in your terminal by running `export DISABLE_SIMPLECOV=true`
4. Direct node to use the ZScaler certificate you downloaded by running `export NODE_EXTRA_CA_CERTS=~/certs/zscaler-root-ca.pem` (modify as appropriate if you placed the cert in a different directory)
5. You can now run Percy. **Note: if there are visual changes it will trigger a Slack alert in the repo owner's Slack channel, so be mindful of running this if you've modified any pages.** If you're happy to proceed, run `yarn run percy exec -- bundle exec rspec spec/visual_regression_tests/test_pages_spec.rb --tag visual_regression`. It should take screenshots and upload them to Percy.
