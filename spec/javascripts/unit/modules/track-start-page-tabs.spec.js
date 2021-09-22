describe('Track start page tabs module', function () {
  'use strict'

  beforeEach(function () {
    GOVUK.analytics = { trackEvent: function () {} }
  })

  it('tracks click events on tabs', function () {
    spyOn(GOVUK.analytics, 'trackEvent')

    var container = document.createElement('div')
    container.innerHTML = '<a href="https://example.com/path" class="govuk-tabs__tab">Link</a>'

    var module = new GOVUK.Modules.TrackStartPageTabs(container)
    module.init()

    var link = container.querySelector('a')
    // prevent click causing navigation
    link.addEventListener('click', function (e) { e.preventDefault() })

    link.click()

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'startpages',
      'tab',
      { label: 'https://example.com/path', nonInteraction: true }
    )
  })
})
