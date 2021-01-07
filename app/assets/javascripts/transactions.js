(function () {
  'use strict'

  window.GOVUK = window.GOVUK || {}

  window.GOVUK.Transactions = {
    trackStartPageTabs: function (e) {
      var pagePath = e.target.href
      GOVUK.analytics.trackEvent('startpages', 'tab', { label: pagePath, nonInteraction: true })
    },
    // This is a special case to append a Google Analytics Client ID onto the
    // link to a survey running to ask a question at the covid-19 press
    // conferences. This is hopefully only a short term thing and can be safely
    // deleted once the surevy and/or daily press conferences end.
    appendGaClientIdToAskSurvey: function () {
      if (!window.ga) {
        return
      }

      var links = $('.transaction a[href="https://surveys.publishing.service.gov.uk/ss/govuk-coronavirus-ask"]')

      links.each(function () {
        var $link = $(this)
        window.ga(function (tracker) {
          $link.prop('search', '?_ga=' + tracker.get('clientId'))
        })
      })
    }
  }

  $(document).ready(function () {
    $('form#completed-transaction-form')
      .append('<input type="hidden" name="service_feedback[javascript_enabled]" value="true"/>')
      .append($('<input type="hidden" name="referrer">').val(document.referrer || 'unknown'))

    $('#completed-transaction-form button[type="submit"]').click(function () {
      $(this).attr('disabled', 'disabled')
      $(this).parents('form').submit()
    })

    $('.transaction .govuk-tabs__tab').click(window.GOVUK.Transactions.trackStartPageTabs)

    window.GOVUK.Transactions.appendGaClientIdToAskSurvey()
  })
})()
