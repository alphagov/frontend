# Percy tests

Percy tests take screenshots of specific pages, comparing them with previous screenshots of the same pages. If any visual changes are detected, the code owners (which can be found [here](https://docs.publishing.service.gov.uk/repos/frontend.html)) will be notified either via email or on Slack. The goal of this is to reduce blind spots in our test process, as sometimes pages have complex requirements or unique quirks that break when a component or layout is updated. These can be hard to spot in PRs or in the components gem due to the volume of pages on GOV.UK.

Pages are currently added via it having a content item in https://github.com/alphagov/publishing-api/tree/main/content_schemas. Percy is run in the `spec/visual_regression_tests/test_pages_spec.rb` file.

When a page is added to the test list, it will add around 60 screenshots to our monthly usage limit. This is because Percy will take a daily screenshot of a desktop and mobile version of the page. We have a fairly large usage limit, but it's worth double checking before adding pages: https://dashboard.percy.io/usage?org=9d94781c

## Running Percy tests locally

1. Firstly, you'll need to download ZScaler's certificate to your machine. Store it in a directory such as `~/certs/zscaler-root-ca.pem` https://github.com/alphagov/govuk-infrastructure/blob/main/cacerts/zscaler-root-ca.pem
2. [Login to Percy](https://dashboard.percy.io/web/projects/frontend-2026-5462b35e/settings?org=9d94781c) and grab the secret token. Run `export PERCY_TOKEN=[token]` locally, replacing `[token]` with the secret.
3. Disable simplecov in your terminal by running `export DISABLE_SIMPLECOV=true`
4. Direct node to use the ZScaler certificate you downloaded by running `export NODE_EXTRA_CA_CERTS=~/certs/zscaler-root-ca.pem` (modify as appropriate if you placed the cert in a different directory)
5. You can now run Percy. **Note: if there are visual changes it may trigger an alert for the repo owners, so be mindful of running this without giving a heads up first. You should delete any local builds on Percy after testing (see the guidance below on how to do this).** If you're happy to proceed, run `bundle exec rails assets:precompile && yarn run percy exec -- bundle exec rspec spec/visual_regression_tests/test_pages_spec.rb --tag visual_regression`. It should take screenshots and upload them to Percy.

## Deleting a build

You may want to delete a build off of Percy. If so, do the following:

1. Grab the build ID. This is usually the last part of the URL when you view the build. For example for `https://dashboard.percy.io/web/projects/frontend-2026-5462b35e/builds/54493568`, the ID would be `54493568`.
2. Grab your CLI username and access key from Percy. Go to https://browserstack.com/accounts/settings/product and it should be under the `Local Testing` header.
2. Ensure you've set up the ZScaler certificate and have exported the certificate to `NODE_EXTRA_CA_CERTS` (See the "Running Percy tests locally section")
3. Run `npx percy build:delete <build-id> --username <username> --access-key <key>`. Replace `<build-id>`, `<username>` and `<key>` with the appropriate values. For example `npx percy build:delete 54493568 --username janedoe --access-key 1234567` .