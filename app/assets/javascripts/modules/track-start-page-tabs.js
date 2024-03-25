window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  function TrackStartPageTabs (module) {
    this.module = module
    this.init()
  }

  TrackStartPageTabs.prototype.init = function () {
    var tabs = this.module.querySelectorAll('.govuk-tabs__tab')

    for (var i = 0; i < tabs.length; i++) {
      tabs[i].addEventListener('click', this.trackClick.bind(this))
    }
  }

  TrackStartPageTabs.prototype.trackClick = function (event) {
    var pagePath = event.target.href

    if (GOVUK.analytics && GOVUK.analytics.trackEvent) {
      GOVUK.analytics.trackEvent('startpages', 'tab', { label: pagePath, nonInteraction: true })
    }
  }

  Modules.TrackStartPageTabs = TrackStartPageTabs
})(window.GOVUK.Modules)
