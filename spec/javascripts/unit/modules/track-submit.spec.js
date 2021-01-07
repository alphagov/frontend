describe('A form submit tracker', function () {
  'use strict'

  var tracker,
    element

  beforeEach(function () {
    GOVUK.analytics = { trackEvent: function () {} }
    tracker = new GOVUK.Modules.TrackSubmit()
  })

  afterEach(function () {
    delete GOVUK.analytics
  })

  it('tracks submit events', function () {
    spyOn(GOVUK.analytics, 'trackEvent')

    element = $('\
      <div \
        data-track-category="category"\
        data-track-action="action">\
        <form method="post">\
          <button id="submit-button" type="submit">Submit</button>\
        </form>\
      </div>\
    ')

    tracker.start(element)

    element.find('form').trigger('submit')

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('category', 'action')
  })
})
