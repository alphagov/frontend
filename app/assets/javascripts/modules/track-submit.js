window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  Modules.TrackSubmit = function () {
    this.start = function (element) {
      element.on('submit', 'form', trackSubmit)

      var category = element.data('track-category')
      var action = element.data('track-action')

      function trackSubmit () {
        if (GOVUK.analytics && GOVUK.analytics.trackEvent) {
          GOVUK.analytics.trackEvent(category, action)
        }
      }
    }
  }
})(window.GOVUK.Modules)
