describe('tracking smart answer progress', function () {
  'use strict'

  var tracker
  var element

  beforeEach(function () {
    GOVUK.analytics = { trackEvent: function () {} }
    tracker = new GOVUK.Modules.TrackSmartAnswer()
    spyOn(GOVUK.analytics, 'trackEvent')
    spyOn(tracker, 'currentPath').and.returnValue('/the-bridge-of-death/y/sir-lancelot-of-camelot/blue')
  })

  afterEach(function () {
    delete GOVUK.analytics
  })

  describe('when the node type is "outcome"', function () {
    it('tells GA that the smart answer has been completed', function () {
      element = $('\
        <div \
          data-smart-answer-node-type="outcome"\
          data-smart-answer-slug="the-bridge-of-death">\
        </div>\
      ')

      tracker.start(element)

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
        'Simple Smart Answer',
        'Completed',
        {
          label: 'the-bridge-of-death',
          nonInteraction: true,
          page: '/the-bridge-of-death/y/sir-lancelot-of-camelot/blue'
        }
      )
    })

    it('will not track anything if the title is missing', function () {
      element = $('\
        <div \
          data-smart-answer-node-type="outcome">\
        </div>\
      ')

      tracker.start(element)

      expect(GOVUK.analytics.trackEvent).not.toHaveBeenCalled()
    })
  })

  it('will not track events for other smart answer node types', function () {
    element = $('\
      <div \
        data-smart-answer-node-type="question"\
        data-smart-answer-slug="the-bridge-of-death">\
      </div>\
    ')

    tracker.start(element)

    expect(GOVUK.analytics.trackEvent).not.toHaveBeenCalled()
  })

  it('will not track events when the node type is missing', function () {
    element = $('\
      <div \
        data-smart-answer-slug="the-bridge-of-death">\
      </div>\
    ')

    tracker.start(element)

    expect(GOVUK.analytics.trackEvent).not.toHaveBeenCalled()
  })
})
