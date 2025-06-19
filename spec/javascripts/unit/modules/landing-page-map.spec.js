describe('Map Block module', function () {
  'use strict'

  var el, module

  function createMapDom (apiKey) {
    el = document.createElement('div')
    el.innerHTML = `
      <div id="mapfilter-hint" class="govuk-hint">Filter by</div>
        <div class="govuk-checkboxes">
          <div class="govuk-checkboxes__item">
            <input type="checkbox" name="favourite_small_synonym[]" id="mapfilter-0" value="cdc" class="govuk-checkboxes__input" checked=""><label for="mapfilter-0" class="govuk-label govuk-checkboxes__label">Community Diagnostic Centres</label>
          </div>
          <div class="govuk-checkboxes__item">
            <input type="checkbox" name="favourite_small_synonym[]" id="mapfilter-1" value="sh" class="govuk-checkboxes__input" checked=""><label for="mapfilter-1" class="govuk-label govuk-checkboxes__label">Surgical hubs</label>
          </div>
        </div>
      </fieldset>
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
    function setupMap (apiKey = '') {
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
      setupMap() // need to pass an empty string, otherwise becomes the string 'undefined'
      expect(module.initialiseMap).not.toHaveBeenCalled()
      expect(el.querySelector('.map__canvas').innerText).toEqual("We're sorry, but the map failed to load. Please try reloading the page.")
    })

    it('tries to start when an API key is present', function () {
      setupMap('not_really_the_key')
      expect(module.initialiseMap).toHaveBeenCalled()
    })
  })

  describe('when initialising analytics', function () {
    function setupMap (allowCookies) {
      if (allowCookies) {
        agreeToCookies()
      } else {
        denyCookies()
      }
      createMapDom('not_really_the_key')
      module = new GOVUK.Modules.LandingPageMap(el.querySelector('.map__canvas'))
      // need to spy on all these functions so they don't call through and error
      spyOn(module, 'initialiseMap')
      spyOn(module, 'enableTracking')
      spyOn(module, 'addOverlays')
      module.init()
    }

    it('does not initialise analytics if consent is rejected', function () {
      setupMap(false)
      expect(module.enableTracking).not.toHaveBeenCalled()
    })

    it('does initialise analytics if consent is given', function () {
      setupMap(true)
      expect(module.enableTracking).toHaveBeenCalled()
    })

    it('initialises analytics if consent is given later', function () {
      window.GOVUK.Modules = window.GOVUK.Modules || {}
      setupMap(false)
      expect(module.enableTracking).not.toHaveBeenCalled()
      module.enableTracking.calls.reset()

      agreeToCookies()
      window.GOVUK.triggerEvent(window, 'cookie-consent')
      expect(module.enableTracking).toHaveBeenCalled()
    })
  })

  describe('enable tracking', function () {
    it('sets the right attributes', function () {
      createMapDom('not_really_the_key')
      module = new GOVUK.Modules.LandingPageMap(el.querySelector('.map__canvas'))
      window.GOVUK.Modules.Ga4AutoTracker = class Ga4AutoTracker {}
      module.enableTracking()
      expect(module.tracking).toEqual(true)
      expect(module.ga4Attributes).toEqual({ section: 'Find local CDCs and surgical hubs near you', tool_name: 'community diagnostics centres and surgical hubs' })
    })
  })

  describe('when tracking is disabled', function () {
    it('sendTracking does nothing', function () {
      createMapDom('not_really_the_key')
      module = new GOVUK.Modules.LandingPageMap(el.querySelector('.map__canvas'))
      module.tracker = {
        sendEvent: function () {}
      }
      spyOn(module.tracker, 'sendEvent')
      module.initialiseMap()
      module.addOverlays()
      module.sendTracking()
      expect(module.tracker.sendEvent).not.toHaveBeenCalled()
    })
  })

  describe('analytics events', function () {
    var attributes

    beforeEach(function () {
      createMapDom('not_really_the_key')
      module = new GOVUK.Modules.LandingPageMap(el.querySelector('.map__canvas'))
      module.initialiseMap()
      module.addOverlays()
      module.tracking = true // force the tracking to call even though not initialised properly
      module.tracker = {
        sendEvent: function () {
          attributes = module.$module.getAttribute('data-ga4-auto')
        }
      }
      module.ga4Attributes = {
        section: 'section',
        tool_name: 'tool_name'
      }
    })

    it('sets the right data attributes when a checkbox is used', function () {
      var expected = {
        action: 'select',
        index_link: 1,
        index_total: 2,
        text: 'community diagnostic centres',
        event_name: 'select_content',
        type: 'map',
        section: 'section',
        tool_name: 'tool_name'
      }
      el.querySelector('#mapfilter-0').click()
      expect(attributes).toEqual(JSON.stringify(expected))
    })

    // this test is a bit brittle as it depends on specific data, but at least it's tested
    it('tracks when popups are clicked', function () {
      var expected = {
        action: 'opened',
        text: 'Yeovil Elective Orthopaedic Centre',
        event_name: 'select_content',
        type: 'map',
        section: 'section',
        tool_name: 'tool_name'
      }

      var marker = el.querySelectorAll('.leaflet-marker-icon')
      marker[marker.length - 1].click() // click the last popup
      expect(attributes).toEqual(JSON.stringify(expected))
    })

    it('tracks when the sendTracking function is called', function () {
      var extraAttributes = {
        action: 'opened',
        text: 'Yeovil Elective Orthopaedic Centre'
      }
      var expected = {
        action: 'opened',
        text: 'Yeovil Elective Orthopaedic Centre',
        event_name: 'select_content',
        type: 'map',
        section: 'section',
        tool_name: 'tool_name'
      }

      module.sendTracking(extraAttributes)
      expect(attributes).toEqual(JSON.stringify(expected))
    })
  })

  describe('creating the map', function () {
    beforeEach(function () {
      createMapDom('not_really_the_key')
      module = new GOVUK.Modules.LandingPageMap(el.querySelector('.map__canvas'))
    })

    it('initialises the basic map object', function () {
      expect(module.map).toEqual(undefined)
      module.initialiseMap()
      // check for the most basic property created by the map initialising
      expect(module.map).toEqual(jasmine.objectContaining({
        _initHooksCalled: true
      }))
    })

    it('adds overlays to the map', function () {
      expect(module.map).toEqual(undefined)
      module.initialiseMap()
      module.addOverlays()

      expect(Object.keys(module.map._panes)).toContain('cdc')
      expect(Object.keys(module.map._panes)).toContain('hub')
      expect(Object.keys(module.map._panes)).toContain('ics')
    })
  })

  describe('creating and populating an element', function () {
    beforeEach(function () {
      createMapDom('not_really_the_key')
      module = new GOVUK.Modules.LandingPageMap(el.querySelector('.map__canvas'))
    })

    it('creates a basic element', function () {
      const divEl = module.createAndPopulateElement('div')
      expect(divEl).toEqual(document.createElement('div'))
    })

    it('creates an element containing text', function () {
      const divEl = module.createAndPopulateElement('p', 'hello there')
      const expected = document.createElement('p')
      expected.innerText = 'hello there'
      expect(divEl).toEqual(expected)
    })

    it('creates an element with text and a class', function () {
      const divEl = module.createAndPopulateElement('h2', 'hello there', 'example-class')
      const expected = document.createElement('h2')
      expected.innerText = 'hello there'
      expected.classList.add('example-class')
      expect(divEl).toEqual(expected)
    })

    it('creates an element with text and multiple classes', function () {
      const divEl = module.createAndPopulateElement('h2', 'hello there', 'example-class another-class')
      const expected = document.createElement('h2')
      expected.innerText = 'hello there'
      expected.classList.add('example-class')
      expected.classList.add('another-class')
      expect(divEl).toEqual(expected)
    })
  })

  describe('get heading and prop', function () {
    beforeEach(function () {
      createMapDom('not_really_the_key')
      module = new GOVUK.Modules.LandingPageMap(el.querySelector('.map__canvas'))
    })

    it('returns correct information for a CDC point', function () {
      const ftGeomType = 'Point'
      const ftProps = {
        name: 'ftPropsName'
      }
      const lyrPane = 'cdc'
      const result = module.getHeadingAndProp(ftGeomType, ftProps, lyrPane)
      const expected = [
        'ftPropsName',
        {
          services: 'Services offered',
          isOpen12_7: 'Open 12 hours a day, 7 days a week?',
          address: 'Address'
        }
      ]
      expect(result).toEqual(expected)
    })

    it('returns correct information for a hub point', function () {
      const ftGeomType = 'Point'
      const ftProps = {
        name: 'ftPropsName'
      }
      const lyrPane = 'hub'
      const result = module.getHeadingAndProp(ftGeomType, ftProps, lyrPane)
      const expected = [
        'ftPropsName',
        {
          address: 'Address'
        }
      ]
      expect(result).toEqual(expected)
    })

    it('returns correct information for region', function () {
      window.GOVUK.lookup.ics = ['fake']
      const ftGeomType = ''
      const ftProps = {
        ICB23CD: 0
      }
      const lyrPane = 'hub'
      const result = module.getHeadingAndProp(ftGeomType, ftProps, lyrPane)
      const expected = [
        'fake',
        {
          cdcCount: 'Community Diagnostic Centres',
          hubCount: 'Surgical Hubs'
        }
      ]
      expect(result).toEqual(expected)
    })
  })

  describe('create popup element functions', function () {
    beforeEach(function () {
      createMapDom('not_really_the_key')
      module = new GOVUK.Modules.LandingPageMap(el.querySelector('.map__canvas'))
    })

    it('returns html for the popup heading', function () {
      const expected = document.createElement('h3')
      expected.classList.add('govuk-heading-m')
      expected.classList.add('map-popup__heading')
      expected.innerText = 'text'
      expect(module.createPopupHeading('text')).toEqual(expected)
    })

    it('returns empty html for the popup body if nothing is passed', function () {
      const propLookup = {}
      const ftProps = {}
      const expected = document.createElement('div')
      expect(module.createPopupBody(propLookup, ftProps)).toEqual(expected)
    })

    it('returns html for a regional popup', function () {
      const propLookup = { cdcCount: 'Community Diagnostic Centres', hubCount: 'Surgical Hubs' }
      const ftProps = { ICB23CD: 'E54000064', NHSER22CD: 'E40000005', cdcCount: 7, hubCount: 2 }
      const expected = document.createElement('div')
      expected.innerHTML = '<h4 class="govuk-heading-s govuk-!-margin-0">Community Diagnostic Centres</h4><p class="govuk-body">7</p><h4 class="govuk-heading-s govuk-!-margin-0">Surgical Hubs</h4><p class="govuk-body">2</p>'
      expect(module.createPopupBody(propLookup, ftProps)).toEqual(expected)
    })
  })
})
