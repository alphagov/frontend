describe('Map component', function () {
  'use strict'

  var el, module

  function setupMap (apiKey = '', config = {}, markers = {}, url = '') { // need to pass an empty string, otherwise becomes the string 'undefined'
    el = document.createElement('div')
    el.innerHTML = `
      <div
        class="for-testing"
        id="map-1234"
        data-api-key="${apiKey}"
        data-config='${JSON.stringify(config)}'
        data-markers='${JSON.stringify(markers)}'
        data-geojson='${url}'>
        <div class="app-c-map"></div>
      </div>
    `
    document.body.appendChild(el)
    module = new GOVUK.Modules.Map(el.querySelector('#map-1234'))
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

  const markers = [
    {
      lat: 5,
      lng: 4,
      popupContent: 'some content'
    }
  ]

  afterEach(function () {
    document.body.removeChild(el)
  })

  it('initialising the map without a key does nothing', function () {
    setupMap()
    // need to spy on these functions so they don't call through and error
    spyOn(module, 'initialiseMap')
    spyOn(module, 'addAllMarkers')
    module.init()

    expect(module.initialiseMap).not.toHaveBeenCalled()
    expect(el.querySelector('#map-1234').innerText).toEqual("We're sorry, but the map failed to load. Please try reloading the page.")
  })

  // map is prevented from loading if config not passed by the template
  // but this assumes we've passed that point
  describe('initialising the map correctly', function () {
    beforeEach(function () {
      setupMap('pretend_key')
      spyOn(module, 'initialiseMap').and.callThrough()
      module.init()
    })

    it('calls the initialiseMap function', function () {
      expect(module.initialiseMap).toHaveBeenCalled()
    })

    it('has default config', function () {
      expect(module.config).toEqual(defaultMapConfig)
    })

    it('configures the map element', function () {
      expect(el.querySelector('.for-testing').getAttribute('id')).toEqual('')
      expect(el.querySelector('.app-c-map').getAttribute('id')).toEqual('map-1234')
      expect(el.querySelector('.app-c-map')).toHaveClass('app-c-map--enabled')
    })
  })

  describe('with passed options', function () {
    const config = {
      centre_lat: 1,
      centre_lng: 2,
      zoom: 9
    }

    beforeEach(function () {
      setupMap('pretend_key', config)
      module.init()
    })

    it('accepts basic config', function () {
      expect(module.config.centre_lat).toEqual(1)
      expect(module.config.centre_lng).toEqual(2)
      expect(module.config.zoom).toEqual(9)
    })
  })

  describe('with passed markers', function () {
    beforeEach(function () {
      setupMap('pretend_key', {}, markers)
      module.init()
    })

    it('adds map markers', function () {
      expect(module.markers).toEqual(markers)
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

  describe('when given a geojson that returns as 404', function () {
    beforeEach(function () {
      spyOn(window, 'fetch').and.resolveTo(new Response(false, {
        status: 404,
        headers: { 'Content-Type': 'application/json' }
      }))
    })

    it('fails silently', async () => {
      setupMap('apiKey', {}, {}, '/fake/test.geojson')
      spyOn(module, 'addAllMarkers').and.callThrough()
      module.initialiseMap()
      await module.addAllMarkers()

      expect(window.fetch).toHaveBeenCalled()
      expect(module.popups.length).toEqual(0)
    })

    it('successfully adds other markers', async () => {
      setupMap('apiKey', {}, markers, '/fake/test.geojson')
      spyOn(module, 'addAllMarkers').and.callThrough()
      module.initialiseMap()
      await module.addAllMarkers()

      expect(window.fetch).toHaveBeenCalled()
      expect(module.popups.length).toEqual(1)
    })
  })

  describe('when given valid geojson', function () {
    beforeEach(function () {
      spyOn(window, 'fetch').and.resolveTo(new Response(JSON.stringify(fakeGeoJson), {
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      }))
    })

    it('adds markers and popups from a geojson URL', async () => {
      setupMap('apiKey', {}, {}, '/fake/test.geojson')
      module.initialiseMap()
      await module.addAllMarkers()

      expect(window.fetch).toHaveBeenCalled()
      expect(module.popups.length).toEqual(2)
      expect(module.popups[0]._popup._content).toEqual('Birmingham')
    })

    it('adds manual and geojson markers', async () => {
      const marker = [
        {
          lat: 51.5163,
          lng: -0.1766,
          popupContent: 'Paddington',
          alt: 'Paddington Station'
        }
      ]
      setupMap('apiKey', {}, marker, '/fake/test.geojson')
      module.initialiseMap()
      await module.addAllMarkers()

      expect(window.fetch).toHaveBeenCalled()
      expect(module.popups.length).toEqual(3)
      expect(module.popups[0]._popup._content).toEqual('Birmingham')
      expect(module.popups[2]._popup._content).toEqual('Paddington')
    })
  })
})
