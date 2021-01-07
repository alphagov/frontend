window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  Modules.TrackSmartAnswer = function () {
    this.start = function (element) {
      var nodeType = element.data('smart-answer-node-type')
      var flowSlug = element.data('smart-answer-slug')

      if ((nodeType === undefined) || (flowSlug === undefined)) {
        return
      }

      var trackingOptions = {
        label: flowSlug,
        nonInteraction: true,
        page: this.currentPath()
      }

      var trackSmartAnswer = function (category, action) {
        if (GOVUK.analytics && GOVUK.analytics.trackEvent) {
          GOVUK.analytics.trackEvent(category, action, trackingOptions)
        }
      }

      switch (nodeType) {
        case 'outcome':
          trackSmartAnswer('Simple Smart Answer', 'Completed', trackingOptions)
          break
      }
    }
    this.currentPath = function () {
      return window.location.pathname
    }
  }
})(window.GOVUK.Modules)
