#!/usr/bin/env groovy

node() {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'
  govuk.setEnvar("PUBLISHING_E2E_TESTS_COMMAND", "test-frontend")
  govuk.buildProject(sassLint: false, publishingE2ETests: true)
}
