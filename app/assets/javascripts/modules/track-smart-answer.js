window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  function TrackSmartAnswer (element) {
    this.nodeType = element.getAttribute('data-smart-answer-node-type')
    this.flowSlug = element.getAttribute('data-smart-answer-slug')
    this.init()
  }

  TrackSmartAnswer.prototype.init = function () {
    if (!this.flowSlug || !GOVUK.analytics || !GOVUK.analytics.trackEvent) return

    if (this.nodeType === 'outcome') {
      GOVUK.analytics.trackEvent('Simple Smart Answer', 'Completed', {
        label: this.flowSlug,
        nonInteraction: true,
        page: this.currentPath()
      })
    }
  }

  TrackSmartAnswer.prototype.currentPath = function () {
    return window.location.pathname
  }

  Modules.TrackSmartAnswer = TrackSmartAnswer
})(window.GOVUK.Modules)
