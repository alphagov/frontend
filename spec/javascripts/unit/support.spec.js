describe('Supporting code', function () {
  'use strict'

  describe('browser history method', function () {
    it('returns method replacing history state', function () {
      expect(window.GOVUK.support.history()).toBe(window.history.replaceState)
    })
  })
})
