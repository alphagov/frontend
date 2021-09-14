window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  function TrackSmartAnswer (element) {
    this.$module = element
  }

  TrackSmartAnswer.prototype.init = function () {
    var nodeType = this.$module.getAttribute('data-smart-answer-node-type')
    var flowSlug = this.$module.getAttribute('data-smart-answer-slug')

    if (!nodeType || !flowSlug) {
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

  TrackSmartAnswer.prototype.currentPath = function () {
    return window.location.pathname
  }

  Modules.TrackSmartAnswer = TrackSmartAnswer
})(window.GOVUK.Modules)
