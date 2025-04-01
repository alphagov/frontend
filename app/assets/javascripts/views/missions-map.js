console.log('missions-map.js')
// = require event-target-polyfill/index.js
// = require @defra/flood-map/dist/flood-map.js
// = require @defra/flood-map/dist/flood-map-ui.js
// = require @defra/flood-map/dist/maplibre.js

// import { FloodMap } from '../../src/flood-map.js'
// import { getRequest, getTileRequest } from './request.js'
// import getSymbols from './symbols.js'
// import { addSources, addLayers, toggleVisibility, queryMap } from './layers.js'

// const symbols = getSymbols()

const fm = new FloodMap('map', {
  behaviour: 'hybrid', // 'buttonFirst | inline',
  place: 'Carlisle',
  zoom: 14,
  minZoom: 8,
  maxZoom: 18,
  // center: [-2.938769, 54.893806],
  bounds: [-2.989707, 54.864555, -2.878635, 54.937635],
  // hasReset: true,
  hasGeoLocation: true,
  height: '600px',
  // buttonType: 'anchor',
  // symbols,
  transformRequest: getTileRequest,
  transformSearchRequest: getRequest,
  // geocodeProvider: 'esri-world-geocoder',
  hasAutoMode: true,
  backgroundColor: 'default: #f5f5f0, dark: #162639',
  styles: [{
    name: 'default',
    attribution: `Contains OS data ${String.fromCharCode(169)} Crown copyright and database rights ${(new Date()).getFullYear()}`,
    url: process.env.DEFAULT_URL
  }, {
    name: 'dark',
    attribution: 'Test',
    url: process.env.DARK_URL
  },{
    name: 'aerial',
    attribution: 'Test',
    url: process.env.AERIAL_URL,
    logo: null
  },{
    name: 'deuteranopia',
    attribution: 'Test',
    url: process.env.DEUTERANOPIA_URL
  },{
    name: 'tritanopia',
    attribution: 'Test',
    url: process.env.TRITANOPIA_URL
  }],
  search: {
    country: 'england',
    isAutocomplete: true
  },
  legend: {
    title: 'Menu',
    width: '360px',
    display: 'inset',
    isVisible: true,
    keyDisplay: 'min', // 'all'
    isPersistInUrl: true,
    segments: [
      {
        display: 'timeline',
        items: [
          {
            id: queryMap.live,
            label: 'LIVE'
          },
          {
            id: queryMap.outlook,
            label: '5 days'
          },
          {
            id: queryMap.yearly,
            label: 'Yearly'
          },
          {
            id: queryMap.climate,
            label: '2050'
          }
        ]
      },
      {
        parentIds: [queryMap.outlook],
        display: 'segmented',
        items: [
          {
            id: queryMap.day1,
            label: '<strong>Today</strong>8th'
          },
          {
            id: queryMap.day2,
            label: '<strong>Wed</strong>9th'
          },
          {
            id: queryMap.day3,
            label: '<strong>Thu</strong>10th'
          },
          {
            id: queryMap.day4,
            label: '<strong>Fri</strong>11th'
          },
          {
            id: queryMap.day5,
            label: '<strong>Sat</strong>12th'
          }
        ]
      }
    ],
    key: [
      {
        heading: 'Forecast flood risk',
        layout: 'column',
        parentIds: [queryMap.outlook],
        display: 'ramp',
        items: [
          {
            label: 'Very low',
            fill: '#00703c'
          },
          {
            label: 'Low',
            fill: '#ffdd00'
          },
          {
            label: 'Medium',
            fill: '#f47738'
          },
          {
            label: 'High',
            fill: '#d4351c'
          }
        ]
      },
      {
        heading: 'Annual likelyhood of flooding',
        layout: 'column',
        parentIds: [queryMap.yearly],
        display: 'ramp',
        items: [
          {
            label: '> 3.3%',
            fill: 'default: #75D0E9, dark: #4779C4, aerial: #4779C4'
          },
          {
            label: '> 1%',
            fill: 'default: #B1E2EE, dark: #3C649F, aerial: #3C649F'
          },
          {
            label: '> 0.1%',
            fill: 'default: #D5EBF2, dark: #2C456B, aerial: #2C456B'
          }
        ]
      },
      {
        heading: 'Flood warnings and alerts',
        layout: 'column',
        parentIds: [queryMap.live],
        minZoom: 12,
        items: [
          {
            id: queryMap.severe,
            label: 'Severe',
            fill: '#811418',
            isSelected: true
          },
          {
            id: queryMap.warning,
            label: 'Warning',
            fill: '#E54048',
            isSelected: true
          },
          {
            id: queryMap.alert,
            label: 'Alert',
            fill: '#F09D3E',
            isSelected: true
          },
          {
            id: queryMap.removed,
            label: 'Removed',
            fill: '#778C9D'
          }
        ]
      },
      /*
      {
        heading: 'Flood warnings and alerts',
        layout: 'column',
        parentIds: [queryMap.live],
        maxZoom: 12,
        items: [
          {
            id: queryMap.severe,
            label: 'Severe',
            icon: symbols[0],
            isSelected: true
          },
          {
            id: queryMap.warning,
            label: 'Warning',
            icon: symbols[1]
          },
          {
            id: queryMap.alert,
            label: 'Alert',
            icon: symbols[2]
          },
          {
            id: queryMap.removed,
            label: 'Removed',
            icon: symbols[3]
          }
        ]
      },
      {
        heading: 'Water level measuring stations',
        layout: 'column',
        parentIds: [queryMap.live],
        items: [
          {
            id: queryMap.river,
            label: 'River',
            icon: symbols[5]
          },
          {
            id: queryMap.sea,
            label: 'Sea',
            icon: symbols[7]
          },
          {
            id: queryMap.groundwater,
            label: 'Groundwater',
            icon: symbols[10]
          },
          {
            id: queryMap.rainfall,
            label: 'Rainfall',
            icon: symbols[12]
          }
        ]
      }
      */
    ]
  },
  // info: {
  //   featureId: '011WAFLE',
  //   // coord: [-2.934171,54.901112],
  //   // hasData: true,
  //   width: '360px',
  //   label: '[dynamic title]',
  //   html: '<p class="govuk-body-s">[dynamic body]</p>'
  // },
  queryLocation: {
    layers: ['river-sea-fill', 'surface-water-30-fill', 'surface-water-100-fill', 'surface-water-1000-fill']
  },
  queryFeature: {
    layers: ['warning-fill', 'warning-symbol', 'stations', 'stations-small', 'five-day-forecast']
  }
})
/*
// Component is ready and we have access to map
// We can listen for map events now, such as 'loaded'
fm.addEventListener('ready', e => {
  const map = fm.map
  const isDarkBasemap = ['dark', 'aerial'].includes(e.detail.style)
  addSources(map)
  addLayers(map, isDarkBasemap)
  toggleVisibility(map, e.detail)
})

// Listen for segments, layers or style changes
fm.addEventListener('change', e => {
  const map = fm.map
  const isDarkBasemap = ['dark', 'aerial'].includes(e.detail.style)
  if (e.detail.type === 'style') {
    addSources(map)
    addLayers(fm.map, isDarkBasemap)
  }
  toggleVisibility(fm.map, e.detail)
})

// Listen to map queries
fm.addEventListener('query', e => {
  // Show info panel for feature query
  if (e.detail.resultType === 'feature') {
    const feature = e.detail.features.items[0]
    fm.setInfo({
      width: '360px',
      label: feature.name,
      html: '<p class="govuk-body-s">Feature content2</p>'
    })
  }

  // Show info panel for pixel query
  if (e.detail.resultType === 'pixel') {
    const items = e.detail.features.items
    const sw = items.find(f => f.layer.includes('surface'))?.layer.match(/\d+/)[0]
    const rs = items.find(f => f.prob_4band)?.prob_4band

    const values = ['30', '100', '1000', 'High', 'Medium', 'Low']
    const chance = [3.3, 1, 0.1]
    const source = { sw: 'Surface water', rs: 'Rivers and the sea' }
    const data = { sw: sw ? chance[values.indexOf(sw)] : 0, rs: rs ? chance[values.indexOf(rs) - 3] : 0 }
    const sorted = Object.keys(data).sort((a, b) => { return data[b] - data[a] }).map(k => {
      return {
        source: source[k],
        chance: data[k] === 0 ? 'Less than 0.1%' : `Greater than ${data[k]}%`
      }
    })

    const location = `<p>
            <strong>Latitude/Longitude:</strong> ${e.detail.coord.slice().reverse().join(', ')}
            ${e.detail.place ? '<br/>(Near ' + e.detail.place + ')' : ''}
        </p>`
    const results = sorted.map(a => `<p><strong>${a.source}:</strong> ${a.chance}</p>`).join('')

    fm.setInfo({
      width: '360px',
      label: 'Annual likelihood of flooding',
      html: `
        <div class="govuk-body-s">
          ${location}
          ${results}
        </div>
      `
    })
  }

  // Hide info panel and clear selected feature
  if (!e.detail.resultType) {
    fm.setInfo(null)
  }
})
*/
document.body.classList.add('fm-js-hidden')
console.log('moo')
