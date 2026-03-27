describe('Map component', function () {
  'use strict'

  var el, module

  function createMapDom (apiKey, config, markers, url) {
    el = document.createElement('div')
    el.innerHTML = `
      <div
        id="map-1234"
        data-api-key="${apiKey}"
        data-config='${config}'
        data-markers='${markers}'
        data-geojson='${url}'>
        <div class="app-c-map"></div>
      </div>
    `
    document.body.appendChild(el)
  }

  function setupMap (apiKey = '', config = {}, markers = {}) { // need to pass an empty string, otherwise becomes the string 'undefined'
    createMapDom(apiKey, JSON.stringify(config), JSON.stringify(markers), false)
    module = new GOVUK.Modules.Map(el.querySelector('#map-1234'))
    // need to spy on these functions so they don't call through and error
    spyOn(module, 'initialiseMap')
    spyOn(module, 'addAllMarkers')
    module.init()
  }

  const defaultMapConfig = {
    centre_lat: 51.505,
    centre_lng: -0.09,
    zoom: 8,
    minZoom: 7,
    maxZoom: 16,
    maxBounds: [
      [49.5, -10.5],
      [62, 6]
    ],
    attributionControl: false
  }

  afterEach(function () {
    document.body.removeChild(el)
  })

  describe('when initialising the map', function () {
    it('does nothing if there is no API key', function () {
      setupMap()
      expect(module.initialiseMap).not.toHaveBeenCalled()
      expect(el.querySelector('#map-1234').innerText).toEqual("We're sorry, but the map failed to load. Please try reloading the page.")
    })

    it('tries to start when an API key is present', function () {
      setupMap('pretend_key')
      expect(module.initialiseMap).toHaveBeenCalled()
    })

    // map is prevented from loading if config not passed by the template
    // but this assumes we've passed that point
    it('has default config', function () {
      setupMap('pretend_key')
      expect(module.config).toEqual(defaultMapConfig)
    })

    describe('with passed options', function () {
      it('accepts basic config', function () {
        const config = {
          centre_lat: 1,
          centre_lng: 2,
          zoom: 9
        }
        setupMap('pretend_key', config)
        expect(module.config.centre_lat).toEqual(1)
        expect(module.config.centre_lng).toEqual(2)
        expect(module.config.zoom).toEqual(9)
      })

      it('accepts map markers', function () {
        const markers = [
          {
            lat: 5,
            lng: 4,
            popup_content: 'some content'
          }
        ]
        setupMap('pretend_key', {}, markers)
        expect(module.markers).toEqual(markers)
      })
    })
  })

  const fakeGeoJson = {
    type: 'FeatureCollection',
    features: [
      {
        type: 'Feature',
        properties: {
          popupContent: 'Birmingham'
        },
        geometry: {
          coordinates: [
            -1.89032729180704,
            52.485470314900795
          ],
          type: 'Point'
        }
      },
      {
        type: 'Feature',
        properties: {},
        geometry: {
          coordinates: [
            -2.127508995156802,
            52.5862548496693
          ],
          type: 'Point'
        }
      }
    ]
  }

  describe('when given geojson', function () {
    beforeEach(function () {
      spyOn(window, 'fetch').and.resolveTo(new Response(JSON.stringify(fakeGeoJson), {
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      }))
    })

    it('adds markers and popups from a geojson URL', async () => {
      createMapDom('apiKey', '{}', '{}', '/fake/test.geojson')
      module = new GOVUK.Modules.Map(el.querySelector('#map-1234'))
      module.initialiseMap()
      await module.addAllMarkers()

      expect(window.fetch).toHaveBeenCalled()
      expect(module.popups.length).toEqual(2)
      expect(module.popups[0]._popup._content).toEqual('Birmingham')
    })
  })
})
