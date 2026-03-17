describe('Map component', function () {
  'use strict'

  var el, module

  function setupMap (apiKey, config, markers, url, hideMarkerList) {
    el = document.createElement('div')
    el.setAttribute('class', 'for-testing')
    el.setAttribute('id', 'map-1234')
    if (apiKey) { el.setAttribute('data-api-key', apiKey) }
    if (config) { el.setAttribute('data-config', JSON.stringify(config)) }
    if (markers) { el.setAttribute('data-markers', JSON.stringify(markers)) }
    if (url) { el.setAttribute('data-geojson', JSON.stringify(url)) }
    let markersList = ''
    if ((markers || url) && !hideMarkerList) { markersList = '<div class="js-list-markers"><ul></ul></div>' }
    el.innerHTML = `<div class="app-c-map"></div>${markersList}`
    document.body.appendChild(el)
    module = new GOVUK.Modules.Map(el)
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
      lat: 51.5163,
      lng: -0.1766,
      name: 'Paddington',
      description: 'Paddington Station'
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
    expect(el.innerText).toEqual("We're sorry, but the map failed to load. The map API key was not found.")
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
      expect(el.getAttribute('id')).toEqual('')
      expect(el.querySelector('.app-c-map').getAttribute('id')).toEqual('map-1234')
      expect(el.querySelector('.app-c-map')).toHaveClass('app-c-map--enabled')
      expect(el.querySelectorAll('.js-list-markers li').length).toEqual(0)
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
      setupMap('pretend_key', false, markers)
      module.init()
    })

    it('adds map markers to the map', function () {
      expect(module.markers).toEqual(markers)
    })

    it('adds a list of markers beneath the map', function () {
      expect(el.querySelectorAll('.js-list-markers li').length).toEqual(1)
      expect(el.querySelector('.js-list-markers li:first-child').innerText).toEqual('Paddington')
    })
  })

  const fakeGeoJson = {
    type: 'FeatureCollection',
    features: [
      {
        type: 'Feature',
        properties: {
          name: 'Birmingham',
          description: 'A city'
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
        properties: {
          name: 'Wolverhampton'
        },
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
      setupMap('apiKey', false, false, '/fake/test.geojson')
      spyOn(module, 'addAllMarkers').and.callThrough()
      module.initialiseMap()
      await module.addAllMarkers()

      expect(window.fetch).toHaveBeenCalled()
      expect(module.popups.length).toEqual(0)
    })

    it('successfully adds other markers', async () => {
      setupMap('apiKey', false, markers, '/fake/test.geojson')
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
      setupMap('apiKey', false, false, '/fake/test.geojson')
      module.initialiseMap()
      await module.addAllMarkers()

      expect(window.fetch).toHaveBeenCalled()
      expect(module.popups.length).toEqual(2)
      expect(module.popups[0]._popup._content).toEqual('<strong>Birmingham</strong><br>A city')
    })
  })

  describe('when given geojson and markers', function () {
    beforeEach(function () {
      spyOn(window, 'fetch').and.resolveTo(new Response(JSON.stringify(fakeGeoJson), {
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      }))
      setupMap('apiKey', false, markers, '/fake/test.geojson')
      module.initialiseMap()
    })

    it('adds both types of markers', async () => {
      await module.addAllMarkers()
      expect(module.popups.length).toEqual(3)
      expect(module.popups[0]._popup._content).toEqual('<strong>Birmingham</strong><br>A city')
      expect(module.popups[2]._popup._content).toEqual('<strong>Paddington</strong><br>Paddington Station')
    })

    it('adds a list of both types markers beneath the map', async () => {
      await module.addAllMarkers()
      expect(el.querySelectorAll('.js-list-markers li').length).toEqual(3)
      expect(el.querySelector('.js-list-markers li:nth-child(1)').innerText).toEqual('Birmingham')
      expect(el.querySelector('.js-list-markers li:nth-child(2)').innerText).toEqual('Wolverhampton')
      expect(el.querySelector('.js-list-markers li:nth-child(3)').innerText).toEqual('Paddington')
    })
  })

  describe('when the markers list element is not found', function () {
    beforeEach(function () {
      spyOn(window, 'fetch').and.resolveTo(new Response(JSON.stringify(fakeGeoJson), {
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      }))
      setupMap('apiKey', false, markers, '/fake/test.geojson', true)
      module.initialiseMap()
    })

    it('does not error', async () => {
      await module.addAllMarkers()
      expect(el.querySelectorAll('.js-list-markers li').length).toEqual(0)
    })
  })
})
