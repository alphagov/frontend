window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  function TransactionSurveyForm (module) {
    this.module = module
    this.init()
  }

  TransactionSurveyForm.prototype.init = function () {
    this.appendJsFields()
    this.disableOnSubmit()
  }

  TransactionSurveyForm.prototype.appendJsFields = function () {
    var jsEnabledInput = document.createElement('input')
    jsEnabledInput.type = 'hidden'
    jsEnabledInput.name = 'service_feedback[javascript_enabled]'
    jsEnabledInput.value = 'true'
    this.module.appendChild(jsEnabledInput)

    var referrerInput = document.createElement('input')
    referrerInput.type = 'hidden'
    referrerInput.name = 'referrer'
    referrerInput.value = document.referrer || 'unknown'
    this.module.appendChild(referrerInput)
  }

  TransactionSurveyForm.prototype.disableOnSubmit = function () {
    var button = this.module.querySelector('button[type="submit"]')
    this.module.addEventListener('submit', function () {
      if (button) {
        button.disabled = true
      }
    })
  }

  Modules.TransactionSurveyForm = TransactionSurveyForm
})(window.GOVUK.Modules)
