window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  function TrackSubmit (element) {
    this.$module = element
    this.formElement = this.$module.querySelector('form')
    this.init()
  }

  TrackSubmit.prototype.init = function () {
    if (this.formElement) {
      var category = this.$module.getAttribute('data-track-category')
      var action = this.$module.getAttribute('data-track-action')

      this.formElement.addEventListener('submit', function () {
        if (GOVUK.analytics && GOVUK.analytics.trackEvent) {
          GOVUK.analytics.trackEvent(category, action)
        }
      })
    }
  }

  Modules.TrackSubmit = TrackSubmit
})(window.GOVUK.Modules)
