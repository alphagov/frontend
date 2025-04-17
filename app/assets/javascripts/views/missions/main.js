/* global L */
//= require leaflet
//= require views/missions/data/cdc.geojson.js
//= require views/missions/data/hub.geojson.js
//= require views/missions/data/icb.geojson.js

window.addEventListener('DOMContentLoaded', function () {
  if (!document.getElementById('map')) {
    return
  }

  const apiKey = ''

  if(!apiKey) {
    let warning = document.querySelector("#api-warning")
    warning.innerText = "Please supply the API Key from the Trello card, otherwise map image tiles will not populate."
  }

  // Initialize the map.
  const mapOptions = {
    minZoom: 7,
    maxZoom: 16,
    center: [51.063, -1.319],
    zoom: 8,
    maxBounds: [
      [49.528423, -10.76418],
      [61.331151, 1.9134116]
    ],
    attributionControl: false
  }

  const map = L.map('map', mapOptions)

  // Load and display ZXY tile layer on the map.
  L.tileLayer('https://api.os.uk/maps/raster/v1/zxy/Light_3857/{z}/{x}/{y}.png?key=' + apiKey, {
    attribution: `Contains OS data &copy; Crown copyright and database rights ${new Date().getFullYear()}`,
    maxZoom: 20
  }).addTo(map)

  // window.GOVUK.icbGeojson and similar are declared in data files in views/missions/data

  // Takes the icbGeoJSON and creates an object that looks like
  // {E1234567: "A UK Region", E1234568: "Another UK Region"} etc.
  // E numbers are region codes.
  // These are the more specific clickable UK 'regions' on the map
  const icbLookup = window.GOVUK.icbGeojson.features.reduce((obj, v) => ({ ...obj, [v.properties.ICB23CD]: v.properties.ICB23NM }), {})

  // Creates an object with large UK regions e.g. { E12345678: "South East", }
  const nhsLookup = window.GOVUK.icbGeojson.features.reduce((obj, v) => ({ ...obj, [v.properties.NHSER22CD]: v.properties.NHSER22NM }), {})

  // Colours for each large UK region
  const colorLookup = {
    E40000003: '#FF1F5B',
    E40000005: '#00CD6C',
    E40000006: '#009ADE',
    E40000007: '#AF58BA',
    E40000010: '#FFC61E',
    E40000011: '#F28522',
    E40000012: '#A0B1BA'
  }

  // Add the DHSC Community Diagnostic Centre (CDC) locations.
  // AKA the clickable black circles on the map
  map.createPane('cdc')
  map.getPane('cdc').style.zIndex = 650

  const cdcCustomOverlay = L.geoJSON(window.GOVUK.cdcGeojson, {
    onEachFeature: bindPopup,
    pointToLayer: function (feature, latlng) {
      return L.circleMarker(latlng)
    },
    style: function (feature) {
      return {
        color: '#fff',
        fillColor: '#000',
        fillOpacity: 1,
        radius: 5,
        weight: 2,
        pane: 'cdc'
      }
    }
  }).addTo(map)
  const cdcOverlay = cdcCustomOverlay

  // Add the DHSC surgical hub locations.
  // AKA the clickable white circles on the map
  map.createPane('hub')
  map.getPane('hub').style.zIndex = 651

  const hubCustomOverlay = L.geoJSON(window.GOVUK.hubGeojson, {
    onEachFeature: bindPopup,
    pointToLayer: function (feature, latlng) {
      return L.circleMarker(latlng)
    },
    style: function (feature) {
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
  const icbCdcCount = cdcOverlay.toGeoJSON().features.reduce(function (obj, v) {
    obj[v.properties.ICS_ICB] = (obj[v.properties.ICS_ICB] || 0) + 1
    return obj
  }, {})

  const icbCdcIsOpenCount = cdcOverlay.toGeoJSON().features
    .filter((key, index) => key.properties.isOpen === 'Yes')
    .reduce((obj, v) => {
      obj[v.properties.icbCode] = (obj[v.properties.icbCode] || 0) + 1
      return obj
    }, {})

  const icbCdcIsFullOpenCount = cdcOverlay.toGeoJSON().features
    .filter((key, index) => key.properties.isOpen12_7 === 'Yes')
    .reduce((obj, v) => {
      obj[v.properties.icbCode] = (obj[v.properties.icbCode] || 0) + 1
      return obj
    }, {})

  const icbHubCount = hubOverlay.toGeoJSON().features.reduce(function (obj, v) {
    obj[v.properties.ICS_ICB] = (obj[v.properties.ICS_ICB] || 0) + 1
    return obj
  }, {})

  const icbHubIsOpenCount = hubOverlay.toGeoJSON().features
    .filter((key, index) => key.properties.isOpen === 'Yes')
    .reduce((obj, v) => {
      obj[v.properties.icbCode] = (obj[v.properties.icbCode] || 0) + 1
      return obj
    }, {})

  window.GOVUK.icbGeojson.features.forEach((element) => {
    element.properties.cdcCount = icbCdcCount[element.properties.ICB23CD] || 0
    element.properties.cdcOpen = icbCdcIsOpenCount[element.properties.ICB23CD] || 0
    element.properties.cdcFullOpen = icbCdcIsFullOpenCount[element.properties.ICB23CD] || 0
    element.properties.hubCount = icbHubCount[element.properties.ICB23CD] || 0
    element.properties.hubOpen = icbHubIsOpenCount[element.properties.ICB23CD] || 0
  })

  // Add the Integrated Care Board (IBC) boundaries. (i.e. the UK sub-regions)
  map.createPane('icb')
  map.getPane('icb').style.zIndex = 450

  const icb = L.geoJson(window.GOVUK.icbGeojson, {
    onEachFeature: bindPopup,
    style: function (feature) {
      return {
        color: '#fff',
        fillColor: colorLookup[feature.properties.NHSER22CD],
        fillOpacity: 0.5,
        weight: 1,
        pane: 'icb'
      }
    }
  }).addTo(map)

  // Rough code to demonstrate filters.

  const layers = [icb, hubOverlay, cdcOverlay]
  for (let i = 0; i < layers.length; i++) {
    const checkbox = document.querySelector(`#checkbox${i + 1}`)
    const mapLayer = layers[i]
    checkbox.addEventListener('click', function () {
      if (map.hasLayer(mapLayer)) {
        map.removeLayer(mapLayer)
      } else {
        map.addLayer(mapLayer)
      }
    })
  }

  // Binds a popup to the layer with the passed content and sets up the necessary event listeners.
  // I.e. creates the popups that appear when you click on a circle or click on a region
  function bindPopup (feature, layer) {
    let properties = layer.feature.properties
    properties = (({ ICB23CD, NHSER22CD, ...o }) => o)(properties)

    const propLookup = {
      nhsCode: 'nhsName',
      icbCode: 'icbName'
    }

    const table = document.createElement('table')
    table.id = 'popup-table'

    const popupHeading = document.createElement('h1')
    popupHeading.classList.add('govuk-heading')
    popupHeading.classList.add('govuk-heading-m')
    let popupSubheading = ''

    // When you click on a circle, this popup will show up.
    if (layer.feature.geometry.type === 'Point') {
      popupHeading.innerText = properties.name
      let tableRow
      for (const i in properties) {
        if (i !== 'name') {
          const property = /E[\d]+/.test(properties[i]) ? i === 'nhsCode' ? nhsLookup[properties[i]] : icbLookup[properties[i]] : properties[i]
          tableRow = document.createElement('tr')
          const tableDataLabel = document.createElement('td')
          tableDataLabel.innerText = propLookup[i] || i
          const tableDataValue = document.createElement('td')
          tableDataValue.innerText = property

          tableRow.appendChild(tableDataLabel)
          tableRow.appendChild(tableDataValue)
          table.appendChild(tableRow)
        }
      }
    } else {
      // When you click on a region, this popup will show up.

      popupHeading.innerText = `${properties.ICB23NM} Integrated Care Board`
      popupSubheading = document.createElement('h2')
      popupSubheading.classList.add('govuk-heading')
      popupSubheading.classList.add('govuk-heading-s')
      popupSubheading.innerText = `${properties.NHSER22NM} NHS Region`

      const tableHeadingsRow = document.createElement('tr')
      const headings = ['&nbsp;', 'Total', 'Open', 'Open 12/7']

      for (const heading of headings) {
        const tableHeading = document.createElement('th')
        tableHeading.innerHTML = heading
        tableHeadingsRow.appendChild(tableHeading)
      }

      const tableCdcRow = document.createElement('tr')
      const tableCdcData = ['CDCs', properties.cdcCount, properties.cdcOpen, properties.cdcFullOpen]
      for (const cdcData of tableCdcData) {
        const tableData = document.createElement('td')
        tableData.innerText = cdcData
        tableCdcRow.appendChild(tableData)
      }

      const tableHubRow = document.createElement('tr')
      const tableHubData = ['Surgical Hubs', properties.hubCount, properties.hubOpen, 'n/a']
      for (const hubData of tableHubData) {
        const tableData = document.createElement('td')
        tableData.innerText = hubData
        tableHubRow.appendChild(tableData)
      }

      table.appendChild(tableHeadingsRow)
      table.appendChild(tableCdcRow)
      table.appendChild(tableHubRow)
    }

    // Add the generated DOM elements above to a container and append it to the popup
    const tableContainer = document.createElement('div')
    tableContainer.appendChild(popupHeading)

    if (popupSubheading) {
      tableContainer.appendChild(popupSubheading)
    }

    tableContainer.appendChild(table)

    const popup = layer.bindPopup(tableContainer)
    const onStyle = layer.feature.geometry.type === 'Point' ? { radius: Math.ceil(layer.options.radius * 1.2) } : { fillOpacity: layer.options.fillOpacity + 0.3 }
    const offStyle = layer.feature.geometry.type === 'Point' ? { radius: layer.options.radius } : { fillOpacity: layer.options.fillOpacity }
    popup.on('popupopen', (e) => { e.target.setStyle(onStyle) })
    popup.on('popupclose', (e) => { e.target.setStyle(offStyle) })
  }
})
