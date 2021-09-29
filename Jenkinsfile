#!/usr/bin/env groovy

library("govuk")

node() {
  govuk.setEnvar("PUBLISHING_E2E_TESTS_COMMAND", "test-frontend")
  govuk.buildProject(
    publishingE2ETests: true
  )
}
