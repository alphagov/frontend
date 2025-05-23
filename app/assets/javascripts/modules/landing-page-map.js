/* global L */
//= require views/landing_page/map/data/lookup.js
//= require views/landing_page/map/data/cdc.geojson.js
//= require views/landing_page/map/data/hub.geojson.js
//= require views/landing_page/map/data/icb.geojson.js

window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  class LandingPageMap {
    constructor ($module) {
      this.$module = $module
      this.apiKey = this.$module.getAttribute('data-api-key')
      const iconSize = [24, 24]
      this.icons = {
        cdc: {
          default: L.icon({ iconUrl: this.$module.getAttribute('data-icon-cdc-default'), iconSize: iconSize, iconAnchor: [24, 12], popupAnchor: [-12, 0] }),
          active: L.icon({ iconUrl: this.$module.getAttribute('data-icon-cdc-active'), iconSize: iconSize, iconAnchor: [24, 12], popupAnchor: [-12, 0] })
        },
        hub: {
          default: L.icon({ iconUrl: this.$module.getAttribute('data-icon-sh-default'), iconSize: iconSize, iconAnchor: [0, 12], popupAnchor: [12, 0] }),
          active: L.icon({ iconUrl: this.$module.getAttribute('data-icon-sh-default'), iconSize: iconSize, iconAnchor: [0, 12], popupAnchor: [12, 0] })
        }
      }
      this.tracking = false
    }

    init () {
      if (!this.apiKey) {
        this.$module.innerText = "We're sorry, but the map failed to load. Please try reloading the page."
        return
      }

      var consentCookie = window.GOVUK.getConsentCookie()
      if (consentCookie && consentCookie.usage) {
        this.enableTracking()
      } else {
        this.startTracking = this.enableTracking.bind(this)
        window.addEventListener('cookie-consent', this.startTracking)
      }

      this.initialiseMap()
      this.addOverlays()
    }

    enableTracking () {
      // initialise the auto tracker on the main map element
      // we will use this for all of the tracking, as it requires direct JS calls
      this.tracking = true
      this.tracker = new GOVUK.Modules.Ga4AutoTracker(this.$module)
      this.ga4Attributes = {}
      this.ga4Attributes.section = 'Find local CDCs and surgical hubs near you'
      this.ga4Attributes.tool_name = 'community diagnostics centres and surgical hubs'
    }

    initialiseMap () {
      this.$module.classList.add('map__canvas--enabled')
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
      this.map = L.map('map', mapOptions)
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
      mask.addTo(this.map)

      // Load and display ZXY tile layer on the map
      const basemap = L.tileLayer(`https://api.os.uk/maps/raster/v1/zxy/Light_3857/{z}/{x}/{y}.png?key=${this.apiKey}`)
      basemap.addTo(this.map)
    }

    addOverlays () {
      const customOverlays = {}

      // Add the Community Diagnostic Centre (CDC) locations.
      this.map.createPane('cdc')
      this.map.getPane('cdc').style.zIndex = 650

      customOverlays.cdc = L.geoJson(window.GOVUK.cdcGeojson, {
        onEachFeature: this.bindPopup,
        pointToLayer: (feature, latlng) => {
          return L.marker(latlng, {
            icon: this.icons.cdc.default,
            pane: 'cdc'
          })
        },
        context: this
      }).addTo(this.map)
      const cdcOverlay = customOverlays.cdc

      // Add the Surgical Hub locations.
      this.map.createPane('hub')
      this.map.getPane('hub').style.zIndex = 651

      customOverlays.hub = L.geoJson(window.GOVUK.hubGeojson, {
        onEachFeature: this.bindPopup,
        pointToLayer: (feature, latlng) => {
          return L.marker(latlng, {
            icon: this.icons.hub.default,
            pane: 'hub'
          })
        },
        context: this
      }).addTo(this.map)
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
      this.map.createPane('ics')
      this.map.getPane('ics').style.zIndex = 450

      const icsOverlay = L.geoJson(window.GOVUK.icbGeojson, {
        onEachFeature: this.bindPopup,
        style: function (feature) {
          return {
            color: '#ccc',
            fillColor: '#ccc',
            fillOpacity: 0,
            weight: 2,
            pane: 'ics'
          }
        },
        context: this
      })
      icsOverlay.addTo(this.map)

      // Fit the map bounds to the extent of the Integrated Care System (ICS) boundaries
      this.map.fitBounds(icsOverlay.getBounds())

      const layers = [cdcOverlay, hubOverlay]
      for (let i = 0; i < layers.length; i++) {
        const checkbox = document.querySelector(`#mapfilter-${i}`)
        const mapLayer = layers[i]

        checkbox.addEventListener('click', () => {
          this.map.closePopup()
          checkbox.checked ? this.map.addLayer(mapLayer) : this.map.removeLayer(mapLayer)

          // track the filter click
          if (this.tracking) {
            this.$module.setAttribute('data-ga4-auto', JSON.stringify({
              event_name: 'select_content',
              action: 'select',
              type: 'map',
              index_link: i + 1,
              index_total: layers.length,
              section: this.ga4Attributes.section,
              text: checkbox.parentElement.innerText.toLowerCase(),
              tool_name: this.ga4Attributes.tool_name
            }))
            this.tracker.sendEvent()
            this.$module.removeAttribute('data-ga4-auto')
          }
        })
      }
    }

    bindPopup (feature, layer) {
      const ftProps = layer.feature.properties
      const ftGeomType = layer.feature.geometry.type
      const lyrPane = layer.options.pane

      const popupContainer = this.context.createAndPopulateElement('div', null, null)
      const popupHeading = this.context.createAndPopulateElement('h3', null, 'govuk-heading-m map-popup__heading')
      popupHeading.setAttribute('data-ga4-text', '')
      const popupBody = this.context.createAndPopulateElement('div', null, null)

      const getHeadingAndPropVals = this.context.getHeadingAndProp(ftGeomType, ftProps, lyrPane)
      popupHeading.innerText = getHeadingAndPropVals[0]
      const propLookup = getHeadingAndPropVals[1]

      for (const [key, value] of Object.entries(propLookup)) {
        if (Object.prototype.hasOwnProperty.call(ftProps, key)) {
          const popupBodyHeading = this.context.createAndPopulateElement('h4', value, 'govuk-heading-s govuk-!-margin-0')
          popupBody.appendChild(popupBodyHeading)

          const popupBodyContent = this.context.createAndPopulateElement('p', ftProps[key], 'govuk-body')
          popupBody.appendChild(popupBodyContent)
        }
      }

      popupContainer.appendChild(popupHeading)
      popupContainer.appendChild(popupBody)

      const popup = layer.bindPopup(popupContainer, { maxWidth: 250 })
      popup.on('popupopen', (e) => {
        if (ftGeomType === 'Point') e.target.setIcon(this.context.icons[lyrPane].active)
        else e.target.setStyle({ fillOpacity: 0.3 })

        const popup = e.target.getPopup()
        const content = popup.getContent()

        if (this.context.tracking) {
          this.context.$module.setAttribute('data-ga4-auto', JSON.stringify({
            event_name: 'select_content',
            action: 'opened',
            type: 'map',
            text: content.querySelector('[data-ga4-text]').innerText || '',
            section: this.context.ga4Attributes.section,
            tool_name: this.context.ga4Attributes.tool_name
          }))
          this.context.tracker.sendEvent()
          this.context.$module.removeAttribute('data-ga4-auto')
        }
      })
      popup.on('popupclose', (e) => {
        if (ftGeomType === 'Point') e.target.setIcon(this.context.icons[lyrPane].default)
        else e.target.setStyle({ fillOpacity: 0.0 })
      })
    }

    createAndPopulateElement (type, text, classes) {
      const element = document.createElement(type)
      if (text) {
        element.innerText = text
      }
      if (classes) {
        classes.split(' ').forEach(function (item) {
          element.classList.add(item)
        })
      }
      return element
    }

    getHeadingAndProp (ftGeomType, ftProps, lyrPane) {
      let innerText
      let propLookup
      if (ftGeomType === 'Point') {
        innerText = ftProps.name

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
        innerText = window.GOVUK.lookup.ics[ftProps.ICB23CD]

        propLookup = {
          cdcCount: 'Community Diagnostic Centres',
          hubCount: 'Surgical Hubs'
        }
      }
      return [innerText, propLookup]
    }
  }

  Modules.LandingPageMap = LandingPageMap
})(window.GOVUK.Modules)
