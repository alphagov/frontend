describe('Transactions', function () {
  describe('trackStartPageTabs', function () {
    var $tabs

    beforeEach(function () {
      $tabs = $('<div class="transaction"><a class="govuk-tabs__tab" href="#foo">Foo</a></div>')
      $('body').append($tabs)
    })

    afterEach(function () {
      $tabs.remove()
    })

    it('pushes a page path including anchor', function () {
      GOVUK.analytics = GOVUK.analytics || { trackEvent: function (args) {} }
      spyOn(GOVUK.analytics, 'trackEvent')

      window.GOVUK.Transactions.trackStartPageTabs({ target: { href: location.href + '#foo' } })

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalled()

      var calledWith = GOVUK.analytics.trackEvent.calls.mostRecent().args
      expect(calledWith[0]).toEqual('startpages')
      expect(calledWith[1]).toEqual('tab')
      expect(calledWith[2]).toEqual({ label: location.href + '#foo', nonInteraction: true })
    })
  })

  describe('appendGaClientIdToAskSurvey', function () {
    var $specialAskTransaction

    window.ga = function (callback) {
      var tracker = { get: function () { return 'clientId' } }
      callback(tracker)
    }

    beforeEach(function () {
      $specialAskTransaction = $('<div class="transaction"><a href="https://surveys.publishing.service.gov.uk/ss/govuk-coronavirus-ask">Start Now</a></div>')
      $('body').append($specialAskTransaction)
    })

    afterEach(function () {
      $specialAskTransaction.remove()
    })

    it('appends the url with the ga clientId', function () {
      window.GOVUK.Transactions.appendGaClientIdToAskSurvey()
      var expectedHref = 'https://surveys.publishing.service.gov.uk/ss/govuk-coronavirus-ask?_ga=clientId'
      expect($specialAskTransaction.find('a').attr('href')).toBe(expectedHref)
    })
  })
})
