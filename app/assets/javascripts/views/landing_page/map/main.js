/* global L */
//= require leaflet
//= require views/landing_page/map/data/lookup.js
//= require views/landing_page/map/data/cdc.geojson.js
//= require views/landing_page/map/data/hub.geojson.js
//= require views/landing_page/map/data/icb.geojson.js

window.addEventListener('DOMContentLoaded', function () {
  const mapElement = document.getElementById('map')
  const apiKey = mapElement.getAttribute('data-api-key')

  if (!mapElement || !apiKey) {
    const warning = document.querySelector('#api-warning')
    warning.innerText = 'Sorry, but the map failed to load. Please try reloading the page.'
    return
  }

  // initialise the auto tracker on the main map element
  // we will use this for all of the tracking, as it requires direct JS calls
  var tracker = new GOVUK.Modules.Ga4AutoTracker(mapElement)
  const ga4Attributes = {}
  ga4Attributes.section = 'Find local CDCs and surgical hubs near you'
  ga4Attributes.tool_name = 'community diagnostics centres and surgical hubs'

  // Initialize the map.
  const mapOptions = {
    minZoom: 7,
    maxZoom: 16,
    zoom: 7,
    maxBounds: [
      [49.5, -10.5],
      [62, 6]
    ],
    attributionControl: false
  }

  const map = L.map('map', mapOptions)

  const mask = L.geoJSON([{
    type: 'FeatureCollection',
    features: [{
      type: 'Feature',
      properties: {},
      geometry: {
        type: 'Polygon',
        coordinates: [
          [[-180, 90], [180, 90], [180, -90], [-180, -90], [-180, 90]],
          [[-11, 49.5], [-11, 62], [3, 62], [3, 51.5], [-3, 49.5], [-11, 49.5]]
        ]
      }
    }]
  }], {
    style: {
      color: '#d7e0e5',
      fillOpacity: 1,
      interactive: false
    }
  })
  mask.addTo(map)

  // Load and display ZXY tile layer on the map.
  const basemap = L.tileLayer(`https://api.os.uk/maps/raster/v1/zxy/Light_3857/{z}/{x}/{y}.png?key=${apiKey}`)
  basemap.addTo(map)

  const iconSize = [24, 24]
  const icons = {
    cdc: {
      default: L.icon({ iconUrl: mapElement.getAttribute('data-icon-cdc-default'), iconSize: iconSize, iconAnchor: [24, 12], popupAnchor: [-12, 0] }),
      active: L.icon({ iconUrl: mapElement.getAttribute('data-icon-cdc-active'), iconSize: iconSize, iconAnchor: [24, 12], popupAnchor: [-12, 0] })
    },
    hub: {
      default: L.icon({ iconUrl: mapElement.getAttribute('data-icon-sh-default'), iconSize: iconSize, iconAnchor: [0, 12], popupAnchor: [12, 0] }),
      active: L.icon({ iconUrl: mapElement.getAttribute('data-icon-sh-default'), iconSize: iconSize, iconAnchor: [0, 12], popupAnchor: [12, 0] })
    }
  }

  const customOverlays = {}

  // Add the Community Diagnostic Centre (CDC) locations.
  map.createPane('cdc')
  map.getPane('cdc').style.zIndex = 650

  customOverlays.cdc = L.geoJson(window.GOVUK.cdcGeojson, {
    onEachFeature: bindPopup,
    pointToLayer: function (feature, latlng) {
      return L.marker(latlng, {
        icon: icons.cdc.default,
        pane: 'cdc'
      })
    }
  }).addTo(map)
  const cdcOverlay = customOverlays.cdc

  // Add the Surgical Hub locations.
  map.createPane('hub')
  map.getPane('hub').style.zIndex = 651

  customOverlays.hub = L.geoJson(window.GOVUK.hubGeojson, {
    onEachFeature: bindPopup,
    pointToLayer: function (feature, latlng) {
      return L.marker(latlng, {
        icon: icons.hub.default,
        pane: 'hub'
      })
    }
  }).addTo(map)
  const hubOverlay = customOverlays.hub

  // Generate CDC and Surgical Hub counts per ICS boundary.
  const icsCdcCount = cdcOverlay.toGeoJSON().features.reduce(function (obj, v) {
    obj[v.properties.icbCode] = (obj[v.properties.icbCode] || 0) + 1
    return obj
  }, {})

  const icsHubCount = hubOverlay.toGeoJSON().features.reduce(function (obj, v) {
    obj[v.properties.icbCode] = (obj[v.properties.icbCode] || 0) + 1
    return obj
  }, {})

  window.GOVUK.icbGeojson.features.forEach((element) => {
    element.properties.cdcCount = icsCdcCount[element.properties.ICB23CD] || '0'
    element.properties.hubCount = icsHubCount[element.properties.ICB23CD] || '0'
  })

  // Add the Integrated Care System (ICS) boundaries.
  map.createPane('ics')
  map.getPane('ics').style.zIndex = 450

  const icsOverlay = L.geoJson(window.GOVUK.icbGeojson, {
    onEachFeature: bindPopup,
    style: function (feature) {
      return {
        color: '#ccc',
        fillColor: '#ccc',
        fillOpacity: 0,
        weight: 2,
        pane: 'ics'
      }
    }
  })
  icsOverlay.addTo(map)

  // Fit the map bounds to the extent of the Integrated Care System (ICS) boundaries
  map.fitBounds(icsOverlay.getBounds())

  const layers = [cdcOverlay, hubOverlay]
  for (let i = 0; i < layers.length; i++) {
    const checkbox = document.querySelector(`#mapfilter-${i}`)
    const mapLayer = layers[i]

    checkbox.addEventListener('click', function () {
      map.closePopup()
      checkbox.checked ? map.addLayer(mapLayer) : map.removeLayer(mapLayer)

      // track the filter click
      mapElement.setAttribute('data-ga4-auto', JSON.stringify({
        event_name: 'select_content',
        action: 'select',
        type: 'map',
        index_link: i + 1,
        index_total: layers.length,
        section: ga4Attributes.section,
        text: checkbox.parentElement.innerText.toLowerCase(),
        tool_name: ga4Attributes.tool_name
      }))
      tracker.sendEvent()
      mapElement.removeAttribute('data-ga4-auto')
    })
  }

  function bindPopup (feature, layer) {
    const ftProps = layer.feature.properties
    const ftGeomType = layer.feature.geometry.type
    const lyrPane = layer.options.pane
    let propLookup

    const popupContainer = document.createElement('div')

    const popupHeading = document.createElement('h3')
    popupHeading.classList.add('govuk-heading-m')
    const popupBody = document.createElement('div')

    if (ftGeomType === 'Point') {
      popupHeading.innerText = ftProps.name

      if (lyrPane === 'cdc') {
        propLookup = {
          services: 'Services offered',
          isOpen12_7: 'Open 12 hours a day, 7 days a week?',
          address: 'Address'
        }
      } else if (lyrPane === 'hub') {
        propLookup = {
          address: 'Address'
        }
      }
    } else {
      popupHeading.innerText = window.GOVUK.lookup.ics[ftProps.ICB23CD]

      propLookup = {
        cdcCount: 'Community Diagnostic Centres',
        hubCount: 'Surgical Hubs'
      }
    }

    for (const [key, value] of Object.entries(propLookup)) {
      if (Object.prototype.hasOwnProperty.call(ftProps, key)) {
        const popupBodyHeading = document.createElement('h4')
        popupBodyHeading.classList.add('govuk-heading-s')
        popupBodyHeading.classList.add('govuk-!-margin-0')
        popupBodyHeading.innerText = value
        popupBody.appendChild(popupBodyHeading)

        const popupBodyContent = document.createElement('p')
        popupBodyContent.classList.add('govuk-body')
        popupBodyContent.innerText = ftProps[key]
        popupBody.appendChild(popupBodyContent)
      }
    }

    popupContainer.appendChild(popupHeading)
    popupContainer.appendChild(popupBody)

    const popup = layer.bindPopup(popupContainer)
    popup.on('popupopen', (e) => {
      if (ftGeomType === 'Point') e.target.setIcon(icons[lyrPane].active)
      else e.target.setStyle({ fillOpacity: 0.3 })

      mapElement.setAttribute('data-ga4-auto', JSON.stringify({
        event_name: 'select_content',
        action: 'opened',
        type: 'map',
        text: ga4Attributes.text,
        section: ga4Attributes.section,
        tool_name: ga4Attributes.tool_name
      }))
      tracker.sendEvent()
      mapElement.removeAttribute('data-ga4-auto')
    })
    popup.on('popupclose', (e) => {
      if (ftGeomType === 'Point') e.target.setIcon(icons[lyrPane].default)
      else e.target.setStyle({ fillOpacity: 0.0 })
    })
  }
})
