/* eslint-env jasmine, jquery */

var $ = window.jQuery

describe('Funding form choices tracker', function () {
  var GOVUK = window.GOVUK || {}
  var tracker
  var $element

  beforeEach(function () {
    GOVUK.analytics = {trackEvent: function () {}}
    spyOn(GOVUK.analytics, 'trackEvent')

    $element = $(
      '<div>' +
        '<form onsubmit="event.preventDefault()" data-question-key="question-key">' +
          '<div>' +
            '<input name="sector_business_area[]" id="construction" type="checkbox" value="construction">' +
            '<label for="construction">Construction label</label>' +
          '</div>' +
          '<div>' +
            '<input name="sector_business_area[]" id="accommodation" type="checkbox" value="accommodation">' +
            '<label for="accommodation">Accommodation label</label>' +
          '</div>' +
          '<div>' +
            '<input name="sector_business_area[]" type="checkbox" value="furniture">' +
          '</div>' +
          '<button type="submit">Next</button>' +
        '</form>' +
      '</div>'
    )

    tracker = new GOVUK.Modules.TrackFundingForm()
    tracker.start($element)
  })

  afterEach(function () {
    delete GOVUK.analytics
  })

  it('tracks checked checkboxes when clicking submit', function () {
    $element.find('input[value="accommodation"]').trigger('click')
    $element.find('input[value="construction"]').trigger('click')
    $element.find('form').trigger('submit')

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'brexit-eu-funding', 'question-key', { transport: 'beacon', label: 'Accommodation label' }
    )
    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'brexit-eu-funding', 'question-key', { transport: 'beacon', label: 'Construction label' }
    )
  })

  it('track events sends value of checkbox when no label is set', function () {
    $element.find('input[value="furniture"]').trigger('click')
    $element.find('form').trigger('submit')

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'brexit-eu-funding', 'question-key', { transport: 'beacon', label: 'furniture' }
    )
  })
})
