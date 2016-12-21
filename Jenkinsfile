#!/usr/bin/env groovy

REPOSITORY = 'frontend'

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  try {
    stage("Checkout") {
      checkout scm
    }

    stage('Clean') {
      govuk.cleanupGit()
    }

    stage('Env') {
      govuk.setEnvar('RAILS_ENV', 'test')
      govuk.setEnvar('DISPLAY', ':99')
      govuk.setEnvar('GOVUK_APP_DOMAIN', 'dev.gov.uk')
    }

    stage('Bundle') {
      govuk.bundleApp()
    }

    stage('Lint') {
      govuk.rubyLinter()
    }

    stage('Clean public directory') {
      sh "rm -rf ${WORKSPACE}/public/frontend"
    }

    stage("Set up content schema dependency") {
      govuk.contentSchemaDependency()
      govuk.setEnvar("GOVUK_CONTENT_SCHEMAS_PATH", "tmp/govuk-content-schemas")
    }

    stage("Build") {
      govuk.runRakeTask('stats')
      govuk.runRakeTask('ci:setup:testunit default')
      govuk.runRakeTask('assets:precompile')
    }

    stage("Result") {
      govuk.pushTag(REPOSITORY, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER)
      govuk.deployIntegration(REPOSITORY, env.BRANCH_NAME, 'release', 'deploy')
    }

  } catch (e) {
    currentBuild.result = "FAILED"
    step([$class: 'Mailer',
    notifyEveryUnstableBuild: true,
    recipients: 'govuk-ci-notifications@digital.cabinet-office.gov.uk',
    sendToIndividuals: true])
    throw e
  }

}
