//= require leaflet
//= require views/missions/data/cdc.geojson.js
//= require views/missions/data/hub.geojson.js
//= require views/missions/data/icb.geojson.js
//= require views/missions/data/lookup.json.js

window.addEventListener("DOMContentLoaded", function () {
  const apiKey = ''

  // Initialize the map.
  const mapOptions = {
    minZoom: 7,
    maxZoom: 16,
    center: [ 51.063, -1.319 ],
    zoom: 7,
    maxBounds: [
      [ 49.528423, -10.76418 ],
      [ 61.331151, 1.9134116 ]
    ],
    attributionControl: false
  }

  const map = L.map('map', mapOptions)

  // Load and display ZXY tile layer on the map.
  const basemap = L.tileLayer('https://api.os.uk/maps/raster/v1/zxy/Light_3857/{z}/{x}/{y}.png?key=' + apiKey, {
    maxZoom: 20
  }).addTo(map)

  let icbLookup = {}
  let nhsLookup = {}

  const colorLookup = {
    E40000003: "#FF1F5B",
    E40000005: "#00CD6C",
    E40000006: "#009ADE",
    E40000007: "#AF58BA",
    E40000010: "#FFC61E",
    E40000011: "#F28522",
    E40000012: "#A0B1BA"
  }

  const baseMaps = {}
  const overlayMaps = {}
  const icbOverlays = {}

  // lookupjson and similar are declared in data files in views/missions/data
  icbLookup = lookupjson.icb
  nhsLookup = lookupjson.nhs

  //Add the DHSC Community Diagnostic Centre (CDC) locations.
  map.createPane('cdc')
  map.getPane('cdc').style.zIndex = 650

  const cdcCustomOverlay = L.geoJSON(cdcGeojson, {
    onEachFeature: bindPopup,
    pointToLayer: function (feature, latlng) {
      return L.circleMarker(latlng)
    },
    style: function(feature) {
      return {
        color: '#fff',
        fillColor: colorLookup[ feature.properties.REGION ],
        fillOpacity: 1,
        radius: 5,
        weight: 2,
        pane: 'cdc'
      }
    }
  }).addTo(map)
  const cdcOverlay = cdcCustomOverlay

  //Add the DHSC surgical hub locations.
  map.createPane('hub')
  map.getPane('hub').style.zIndex = 651

  const hubCustomOverlay = L.geoJSON(hubGeojson, {
    onEachFeature: bindPopup,
    pointToLayer: function (feature, latlng) {
      return L.circleMarker(latlng)
    },
    style: function(feature) {
      return {
        color: '#000',
        fillColor: '#fff',
        fillOpacity: 1,
        radius: 4,
        weight: 1,
        pane: 'hub'
      }
    }
  }).addTo(map)
  const hubOverlay = hubCustomOverlay

  // Generate CDC and surgical hub counts per ICB boundaries.
  let icb_cdcCount = cdcOverlay.toGeoJSON().features.reduce(function(obj, v) {
    obj[ v.properties.ICS_ICB ] = (obj[ v.properties.ICS_ICB ] || 0) + 1
    return obj
  }, {})

  let icb_hubCount = hubOverlay.toGeoJSON().features.reduce(function(obj, v) {
    obj[ v.properties.ICS_ICB ] = (obj[ v.properties.ICS_ICB ] || 0) + 1
    return obj
  }, {})

  icbGeojson.features.forEach((element) => {
    element.properties.CDC_COUNT = icb_cdcCount[element.properties.ICS_ICB] || 0
    element.properties.HUB_COUNT = icb_hubCount[element.properties.ICS_ICB] || 0
  })

  // Add the Integrated Care Board (IBC) boundaries.
  for (const [ key, value ] of Object.entries(nhsLookup)) {
    icbOverlays[key] = L.geoJson(icbGeojson, {
      onEachFeature: bindPopup,
      filter: function(feature) {
        if( feature.properties.REGION === key ) return true
      },
      style: function(feature) {
        return {
          color: '#fff',
          fillColor: colorLookup[ feature.properties.REGION ],
          fillOpacity: 0.5,
          weight: 0.5
        }
      }
    }).addTo(map)

    overlayMaps[`${value} NHS Region`] = icbOverlays[key]
  }

  overlayMaps['Community Diagnostic Centres (All)'] = cdcCustomOverlay
  overlayMaps['Surgical Hubs (All)'] = hubCustomOverlay
  L.control.layers(baseMaps, overlayMaps).addTo(map)

  // Binds a popup to the layer with the passed content and sets up the necessary event listeners.
  function bindPopup(feature, layer) {
    let properties = layer.feature.properties
    const codeRegex = /E[\d]+/

    let content = '<table id="popup-table">'
    for( let i in properties ) {
      if( i === 'REGION' && codeRegex.test(properties[i]) )
        content += `<tr><td>${i}</td><td style="font-weight:600">${nhsLookup[properties[i]]}</td></tr>`
      else if( i === 'ICS_ICB' && codeRegex.test(properties[i]) )
        content += `<tr><td>${i}</td><td style="font-weight:600">${icbLookup[properties[i]]}</td></tr>`
      else
        content += `<tr><td>${i}</td><td style="font-weight:600">${properties[i]}</td></tr>`
    }
    content += '<table>'

    let popup = layer.bindPopup(content)
    if( layer.feature.geometry.type !== 'Point' ) {
      popup.on('popupopen', function(e) {
        e.target.setStyle({ fillOpacity: 0.8 })
      })
      popup.on('popupclose', function(e) {
        e.target.setStyle({ fillOpacity: 0.5 })
      })
    }
  }
})
