/* global defra */
describe('Map component', function () {
  'use strict'

  var el, module

  function setupMap (config, markers, url, hideMarkerList) {
    el = document.createElement('div')
    el.setAttribute('id', 'map-1234')
    if (config) { el.setAttribute('data-config', JSON.stringify(config)) }
    if (markers) { el.setAttribute('data-markers', JSON.stringify(markers)) }
    if (url) { el.setAttribute('data-geojson', url) }
    let markersList = ''
    if ((markers || url) && !hideMarkerList) { markersList = '<div class="app-c-map__markers-list"><div class="js-list-markers"><ol></ol></div></div>' }
    el.innerHTML = `<div class="app-c-map"></div>${markersList}`
    document.body.appendChild(el)
    module = new GOVUK.Modules.Map(el)
  }

  const defaultMapConfig = {
    centre_lat: 51.505,
    centre_lng: -0.09,
    zoom: 8,
    minZoom: 4,
    maxZoom: 16
  }

  const mapConfigWithBounds = {
    centre_lat: 51.505,
    centre_lng: -0.09,
    zoom: 8,
    minZoom: 4,
    bounds: [1, 2, 3, 4]
  }

  const oneMarker = [
    {
      geometry: {
        type: 'Point',
        coordinates: [51.5163, -0.1766]
      },
      properties: {
        name: 'Paddington',
        description: 'A station in London'
      }
    }
  ]

  const twoMarkers = [
    {
      geometry: {
        type: 'Point',
        coordinates: [51.5163, -0.1766]
      },
      properties: {
        name: 'Paddington',
        description: 'A station in London'
      }
    },
    {
      geometry: {
        type: 'Point',
        coordinates: [51.5316, -0.1236]
      },
      properties: {
        name: 'Kings Cross',
        description: 'A station in London'
      }
    }
  ]

  beforeEach(function () {
    spyOn(defra, 'InteractiveMap').and.callFake(function () {
      return {
        on: function () {},
        fitToBounds: function () {},
        addMarker: function () {}
      }
    })
    spyOn(defra, 'interactPlugin').and.callFake(function () {
      return {
        enable: function () {}
      }
    })
  })

  afterEach(function () {
    document.body.removeChild(el)
  })

  // map is prevented from loading if config not passed by the template
  // but this assumes we've passed that point
  describe('initialising the map correctly', function () {
    beforeEach(function () {
      setupMap()
      module.init()
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
      setupMap(config)
      module.init()
    })

    it('accepts basic config', function () {
      expect(module.config.centre_lat).toEqual(1)
      expect(module.config.centre_lng).toEqual(2)
      expect(module.config.zoom).toEqual(9)
    })
  })

  describe('with a passed marker', function () {
    beforeEach(function () {
      setupMap(false, oneMarker)
      module.init()
      spyOn(module.map, 'fitToBounds')
    })

    it('adds map markers to the map', function () {
      expect(module.markers).toEqual(oneMarker)
    })

    it('adds a list of markers beneath the map', function () {
      module.addAllMarkers() // need to call this manually as normally invoked inside 'on', which we've faked
      expect(el.querySelectorAll('.js-list-markers li').length).toEqual(1)
      expect(el.querySelector('.js-list-markers li:first-child').textContent).toEqual('Paddington A station in London')
      expect(module.map.fitToBounds).toHaveBeenCalled()
    })
  })

  describe('with passed markers', function () {
    beforeEach(function () {
      setupMap(false, twoMarkers)
      module.init()
      spyOn(module.map, 'fitToBounds')
    })

    it('adds map markers to the map', function () {
      expect(module.markers).toEqual(twoMarkers)
    })

    it('adds a list of markers beneath the map', function () {
      module.addAllMarkers() // need to call this manually as normally invoked inside 'on', which we've faked
      expect(el.querySelectorAll('.js-list-markers li').length).toEqual(2)
      expect(el.querySelector('.js-list-markers li:first-child').textContent).toEqual('Kings Cross A station in London')
      expect(module.map.fitToBounds).toHaveBeenCalled()
    })
  })

  describe('with a given bounds object', function () {
    beforeEach(function () {
      setupMap(mapConfigWithBounds, twoMarkers)
      module.init()
      spyOn(module.map, 'fitToBounds')
    })

    it('sets its own bounds', function () {
      module.addAllMarkers() // need to call this manually as normally invoked inside 'on', which we've faked
      expect(module.map.fitToBounds).not.toHaveBeenCalled()
    })
  })

  describe('when given a geojson file', function () {
    it('accepts a relative URL', function () {
      setupMap(false, false, '/fake/test.geojson')
      expect(module.geoJsonUrl).toEqual('/fake/test.geojson')
    })

    it('rejects a non-relative URL', function () {
      setupMap(false, false, 'fake/test.geojson')
      expect(module.geoJsonUrl).toEqual(false)
    })

    it('rejects any other URL', function () {
      setupMap(false, false, 'https://example.com/test.geojson')
      expect(module.geoJsonUrl).toEqual(false)
    })
  })

  const fakeGeoJson = {
    type: 'FeatureCollection',
    features: [
      {
        properties: {
          name: 'Birmingham',
          description: 'A city'
        },
        geometry: {
          type: 'Point',
          coordinates: [
            52.485470314900795,
            -1.89032729180704
          ]
        }
      },
      {
        properties: {
          name: 'Wolverhampton'
        },
        geometry: {
          type: 'Point',
          coordinates: [
            52.5862548496693,
            -2.127508995156802
          ]
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
      setupMap(false, false, '/fake/test.geojson')
      spyOn(module, 'addAllMarkers').and.callThrough()
      module.init()
      await module.addAllMarkers()

      expect(window.fetch).toHaveBeenCalled()
      expect(module.markers.length).toEqual(0)
    })

    it('successfully adds other markers', async () => {
      setupMap(false, oneMarker, '/fake/test.geojson')
      spyOn(module, 'addAllMarkers').and.callThrough()
      module.init()
      await module.addAllMarkers()

      expect(window.fetch).toHaveBeenCalled()
      expect(module.markers.length).toEqual(1)
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
      setupMap(false, false, '/fake/test.geojson')
      module.init()
      await module.addAllMarkers()

      expect(window.fetch).toHaveBeenCalled()
      expect(module.markers.length).toEqual(2)
      expect(module.markers[0]).toEqual(fakeGeoJson.features[0])
    })
  })

  describe('when given geojson and markers', function () {
    beforeEach(function () {
      spyOn(window, 'fetch').and.resolveTo(new Response(JSON.stringify(fakeGeoJson), {
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      }))
      setupMap(false, oneMarker, '/fake/test.geojson')
      module.init()
    })

    it('adds both types of markers', async () => {
      await module.addAllMarkers()
      expect(module.markers.length).toEqual(3)
      expect(module.markers[0]).toEqual(fakeGeoJson.features[0])
      expect(module.markers[1]).toEqual(oneMarker[0])
      expect(module.markers[2]).toEqual(fakeGeoJson.features[1])
    })

    it('adds an alphabetical list of both types of markers beneath the map', async () => {
      await module.addAllMarkers()
      expect(el.querySelectorAll('.js-list-markers li').length).toEqual(3)
      expect(el.querySelector('.js-list-markers li:nth-child(1)').textContent).toEqual('Birmingham A city')
      expect(el.querySelector('.js-list-markers li:nth-child(2)').textContent).toEqual('Paddington A station in London')
      expect(el.querySelector('.js-list-markers li:nth-child(3)').textContent).toEqual('Wolverhampton')
    })
  })

  describe('when the markers list element is not found', function () {
    beforeEach(function () {
      spyOn(window, 'fetch').and.resolveTo(new Response(JSON.stringify(fakeGeoJson), {
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      }))
      setupMap(false, oneMarker, '/fake/test.geojson', true)
      module.init()
    })

    it('does not error', async () => {
      await module.addAllMarkers()
      expect(el.querySelectorAll('.js-list-markers li').length).toEqual(0)
    })
  })

  const feature1 = {
    properties: {
      name: 'Name',
      description: 'Description'
    }
  }

  const feature2 = {
    properties: {
      name: 'Name'
    }
  }

  describe('the createPopupContent function', function () {
    beforeEach(function () {
      el = document.createElement('div')
      document.body.appendChild(el)
      module = new GOVUK.Modules.Map(el)
    })

    it('creates content when there is a name and description', function () {
      var result = module.createPopupContent(feature1)
      expect(result).toEqual('<h2 class="govuk-heading-s govuk-!-margin-bottom-2">Name</h2> Description')
    })

    it('creates content when there is only a name', function () {
      var result = module.createPopupContent(feature2)
      expect(result).toEqual('<h2 class="govuk-heading-s govuk-!-margin-bottom-2">Name</h2>')
    })

    it('sets heading levels based on the passed value', function () {
      module.headingLevel = 3
      var result = module.createPopupContent(feature2)
      expect(result).toEqual('<h3 class="govuk-heading-s govuk-!-margin-bottom-2">Name</h3>')
    })
  })

  describe('the addMarkers function', function () {
    const geometryOptions = {
      coordinates: [
        -1.4915442661594511,
        52.40292688379728
      ]
    }
    const defaultMarkerOptions = {
      symbol: 'circle',
      backgroundColor: '#1d70b8',
      foregroundColor: '#FFFFFF',
      haloWidth: 3,
      selectedWidth: 8
    }

    beforeEach(function () {
      el = document.createElement('div')
      document.body.appendChild(el)
      module = new GOVUK.Modules.Map(el)
      spyOn(module, 'addAllMarkers')
      setupMap()
      module.init()
      spyOn(module.map, 'addMarker')
    })

    it('adds regular markers', function () {
      module.markers = [
        {
          geometry: geometryOptions
        }
      ]
      module.addMarkers()
      expect(module.map.addMarker).toHaveBeenCalledWith('marker-0', [-1.4915442661594511, 52.40292688379728], defaultMarkerOptions)
    })

    it('adds markers with custom colours and shapes', function () {
      module.markers = [
        {
          geometry: geometryOptions,
          marker: {
            symbol: 'pin',
            colour: 'orange'
          }
        }
      ]
      module.addMarkers()
      expect(module.map.addMarker).toHaveBeenCalledWith('marker-0', [-1.4915442661594511, 52.40292688379728], Object.assign(Object.assign({}, defaultMarkerOptions), { symbol: 'pin', backgroundColor: '#f47738' }))
    })

    it('ignores invalid custom colours and shapes', function () {
      module.markers = [
        {
          geometry: geometryOptions,
          marker: {
            symbol: 'hat',
            colour: 'yellow'
          }
        }
      ]
      module.addMarkers()
      expect(module.map.addMarker).toHaveBeenCalledWith('marker-0', [-1.4915442661594511, 52.40292688379728], defaultMarkerOptions)
    })
  })
})
