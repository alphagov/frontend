describe('Map Block module', function () {
  'use strict'

  var el, module

  function createMapDom (apiKey) {
    el = document.createElement('div')
    el.innerHTML = `
      <div class="map__canvas"
        id="map"
        data-api-key="${apiKey}"
        data-icon-cdc-default="landing_page/map/CDC-symbol-default.svg"
        data-icon-cdc-active="landing_page/map/CDC-symbol-active.svg"
        data-icon-sh-default="landing_page/map/SH-symbol-default.svg"
        data-icon-sh-active="landing_page/map/SH-symbol-active.svg"
        data-module="ga4-event-tracker">
      </div>
    `
    document.body.appendChild(el)
  }

  function agreeToCookies () {
    GOVUK.setCookie('cookies_policy', '{"essential":true,"settings":true,"usage":true,"campaigns":true}')
  }

  function denyCookies () {
    GOVUK.setCookie('cookies_policy', '{"essential":false,"settings":false,"usage":false,"campaigns":false}')
  }

  afterEach(function () {
    document.body.removeChild(el)
  })

  describe('when initialising the map', function () {
    function setupMap (apiKey) {
      denyCookies()
      createMapDom(apiKey)
      module = new GOVUK.Modules.LandingPageMap(el.querySelector('.map__canvas'))
      // need to spy on all these functions so they don't call through and error
      spyOn(module, 'initialiseMap')
      spyOn(module, 'enableTracking')
      spyOn(module, 'addOverlays')
      module.init()
    }

    it('does nothing if there is no API key', function () {
      setupMap('') // need to pass an empty string, otherwise becomes the string 'undefined'
      expect(module.initialiseMap).not.toHaveBeenCalled()
      expect(el.innerText).toEqual("We're sorry, but the map failed to load. Please try reloading the page.")
    })

    it('tries to start when an API key is present', function () {
      setupMap('not_really_the_key')
      expect(module.initialiseMap).toHaveBeenCalled()
    })
  })

  describe('when initialising analytics', function () {
    function setupMap (apiKey, allowCookies) {
      if (allowCookies) {
        agreeToCookies()
      } else {
        denyCookies()
      }
      createMapDom(apiKey)
      module = new GOVUK.Modules.LandingPageMap(el.querySelector('.map__canvas'))
      // need to spy on all these functions so they don't call through and error
      spyOn(module, 'initialiseMap')
      spyOn(module, 'enableTracking')
      spyOn(module, 'addOverlays')
      module.init()
    }

    it('does not initialise analytics if consent is rejected', function () {
      setupMap('not_really_the_key', false)
      expect(module.enableTracking).not.toHaveBeenCalled()
    })

    it('does initialise analytics if consent is given', function () {
      setupMap('not_really_the_key', true)
      expect(module.enableTracking).toHaveBeenCalled()
    })

    it('initialises analytics if consent is given later', function () {
      window.GOVUK.Modules = window.GOVUK.Modules || {}
      window.GOVUK.Modules.Ga4AutoTracker = {}
      console.log(window.GOVUK)
      // spyOn(window.GOVUK.Modules.Ga4AutoTracker, 'init')
      setupMap('not_really_the_key', false)
      expect(module.enableTracking).not.toHaveBeenCalled()
      module.enableTracking.calls.reset()

      agreeToCookies()
      window.GOVUK.triggerEvent(window, 'cookie-consent')
      expect(module.enableTracking).toHaveBeenCalled()
    })
  })
})
