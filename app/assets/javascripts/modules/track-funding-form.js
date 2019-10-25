window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (global, GOVUK) {
  'use strict'

  var $ = global.jQuery

  GOVUK.Modules.TrackFundingForm = function () {
    this.start = function (element) {
      track(element)
    }

    function track (element) {
      element.on('submit', function (event) {
        var $checkedOption, eventLabel, options
        var $submittedForm = $(event.target)
        var $checkedOptions = $submittedForm.find('input:checked')
        var questionKey = $submittedForm.data('question-key')

        if ($checkedOptions.length) {
          $checkedOptions.each(function (index) {
            $checkedOption = $(this)
            var checkedOptionId = $checkedOption.attr('id')
            var checkedOptionLabel = $submittedForm.find('label[for="' + checkedOptionId + '"]').text().trim()
            eventLabel = checkedOptionLabel.length
              ? checkedOptionLabel
              : $checkedOption.val()

            options = { transport: 'beacon', label: eventLabel }

            GOVUK.analytics.trackEvent('brexit-eu-funding', questionKey, options)
          })
        }
      })
    }
  }
})(window, window.GOVUK)
