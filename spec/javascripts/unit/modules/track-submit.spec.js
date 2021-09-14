describe('A form submit tracker', function () {
  'use strict'

  var tracker,
    element

  beforeEach(function () {
    GOVUK.analytics = { trackEvent: function () {} }
  })

  afterEach(function () {
    delete GOVUK.analytics
  })

  it('tracks submit events', function () {
    spyOn(GOVUK.analytics, 'trackEvent')

    element = $(
      '<div data-track-category="category" data-track-action="action">' +
        '<form method="post">' +
          '<button id="submit-button" type="submit">Submit</button>' +
        '</form>' +
      '</div>'
    )

    tracker = new GOVUK.Modules.TrackSubmit(element[0])
    tracker.init()

    GOVUK.triggerEvent(element.find('form')[0], 'submit')

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('category', 'action')
  })
})
