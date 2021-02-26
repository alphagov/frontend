#!/usr/bin/env groovy

library("govuk")

node() {
  govuk.setEnvar("PUBLISHING_E2E_TESTS_COMMAND", "test-frontend")
  govuk.buildProject(
    publishingE2ETests: true,
    extraParameters: [
      stringParam(
        name: "GDS_API_ADAPTERS_PACT_VERSION",
        defaultValue: "master",
        description: "The branch of gds-api-adapters pact tests to run against"
      ),
    ],
    afterTest : {
      stage("Verify pact with gds-api-adapters") {
        govuk.runRakeTask("pact:verify:branch[${env.GDS_API_ADAPTERS_PACT_VERSION}]")
      }
    }
  )
}
