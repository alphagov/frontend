/* global defra */
/* istanbul ignore next */
window.GOVUK = window.GOVUK || {}
/* istanbul ignore next */
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  class Map {
    constructor ($module) {
      this.$module = $module
      this.map_element = this.$module.querySelector('.app-c-map')
      this.map_id = this.$module.getAttribute('id')
      this.trackingEnabled = this.$module.getAttribute('data-tracking-enabled') === 'true'
      this.headingLevel = parseInt(this.$module.getAttribute('data-heading-level')) || 2
      const cspWorker = this.$module.getAttribute('data-csp-worker')
      this.geoJson = this.$module.getAttribute('data-geojson')
      this.panelId = 'the-panel'

      if (this.geoJson) {
        if (!this.geoJson.startsWith('/') && !this.geoJson.startsWith('data:')) {
          console.error('Error: passed geoJSON must be valid and not be an external URL')
          this.geoJson = false
        }
      }

      let datasetsPlugin = false
      if (this.geoJson) {
        datasetsPlugin = defra.datasetsPlugin({
          datasets: [{
            id: 'features',
            geojson: this.geoJson,
            showInMenu: false,
            minZoom: 1,
            maxZoom: 24, // these must exceed the values used by the map config
            style: {
              symbol: 'circle',
              symbolBackgroundColor: '#1d70b8',
              symbolForegroundColor: '#FFFFFF',
              symbolHaloWidth: 3
            }
          }]
        })
      }

      this.interactPlugin = defra.interactPlugin({
        deselectOnClickOutside: true,
        interactionModes: ['selectFeature'],
        layers: [
          { layerId: 'features', idProperty: 'id', labelProperty: 'name' }
        ]
      })

      const config = {
        mapProvider: defra.maplibreProvider({ workerUrl: cspWorker }),
        behaviour: 'inline',
        mapStyle: {
          url: window.GOVUK.mapComponentStyles,
          backgroundColor: '#f5f5f0',
          attribution: ''
        },
        plugins: [this.interactPlugin, datasetsPlugin],
        urlPosition: 'none',
        minZoom: 4,
        maxZoom: 16,
        center: [-0.09, 51.505],
        containerHeight: '500px'
      }
      const passedConfig = JSON.parse(this.$module.getAttribute('data-config')) || {}
      this.config = Object.assign(config, passedConfig)

      this.markers = JSON.parse(this.$module.getAttribute('data-markers')) || []
      this.key = JSON.parse(this.$module.getAttribute('data-key')) || []

      this.markerOptions = {
        symbol: 'circle',
        backgroundColor: '#1d70b8',
        foregroundColor: '#FFFFFF',
        haloWidth: 3,
        selectedWidth: 8
      }
    }

    init () {
      const id = this.$module.getAttribute('id')
      this.$module.setAttribute('id', '')
      this.map_element.setAttribute('id', id)
      this.map_element.classList.add('app-c-map--enabled')
      this.map = new defra.InteractiveMap(this.map_id, this.config)

      /* istanbul ignore next */
      this.map.on('map:ready', () => {
        this.addAllMarkers()
        this.interactPlugin.enable()
        this.map.addPanel(this.panelId, {
          focus: false,
          label: false,
          showLabel: false,
          html: '<div class="map-panel-content"></div>',
          mobile: { slot: 'drawer', dismissible: true },
          tablet: { slot: 'left-top', dismissible: true, width: '280px' },
          desktop: { slot: 'left-top', dismissible: true, width: '280px' }
        })
        this.map.hidePanel(this.panelId)
      })

      /* istanbul ignore next */
      this.map.on('app:panelopened', () => {
        this.panelOpen = true
        this.sendAnalytics({
          event_name: 'select_content',
          type: 'map',
          action: 'opened',
          text: this.currentMarker
        })
      })

      /* istanbul ignore next */
      this.map.on('app:panelclosed', () => {
        if (this.panelOpen) {
          this.sendAnalytics({
            event_name: 'select_content',
            type: 'map',
            action: 'closed',
            text: this.currentMarker
          })
          this.panelOpen = false
        }
      })

      /* istanbul ignore next */
      this.map.on('interact:selectionchange', (e) => {
        if (!this.panelContent) {
          this.panelContent = this.$module.querySelector('.map-panel-content')
        }

        if (e.selectedFeatures.length > 0) {
          document.getElementById('map-panel-content').innerHTML = this.createPopupContent(e.selectedFeatures[0])
          this.map.showPanel(this.panelId)
          this.sendAnalytics({
            event_name: 'select_content',
            type: 'map',
            action: 'markerClick',
            text: marker.properties.name
          })
        } else {
          this.map.hidePanel(this.panelId)
        }
      })

      /* istanbul ignore next */
      this.map.on('app:panelclosed', (e) => {
        this.interactPlugin.clear()
      })
    }

    createPopupContent (feature) {
      const heading = `h${this.headingLevel}`
      let popupContent = `<${heading} class="govuk-heading-s govuk-!-margin-bottom-2">${feature.properties.name}</${heading}>`
      if (feature.properties.description) {
        popupContent = `${popupContent} <p class="govuk-body govuk-!-margin-bottom-2">${feature.properties.description}</p>`
      }
      feature.marker = feature.marker || {}
      if (feature.marker.name) {
        popupContent = `${popupContent} <p class="govuk-body-s"><span class="app-c-map__key app-c-map__key--${feature.marker.symbol} app-c-map__key--${feature.marker.colour}"></span> ${feature.marker.name}</p>`
      }
      popupContent = this.removeScript(popupContent)
      return popupContent
    }

    removeScript (input) {
      do {
        input = input.replace(/<[\s]*script/g, '')
      } while (input.includes('<script'))
      return input
    }

    async addAllMarkers () {
      if (this.geoJsonUrl) {
        try {
          const response = await fetch(this.geoJsonUrl)
          if (!response.ok) {
            throw new Error(`Response status: ${response.status}`)
          }
          const result = await response.json()
          this.markers = Object.keys(this.markers).length > 0 ? this.markers : []
          this.markers = this.markers.concat(result.features)
        } catch (error) {
          console.error(`${error}, with geojson at ${this.geoJsonUrl}`)
        }
      }

      if (this.markers.length > 0) {
        if (this.key.length) {
          this.markers.forEach(marker => {
            marker.marker = this.key[parseInt(marker.key)] || {}
          })
        }
        this.markers.sort((a, b) => {
          const nameA = a.properties.name.toUpperCase()
          const nameB = b.properties.name.toUpperCase()
          if (nameA < nameB) {
            return -1
          }
          if (nameA > nameB) {
            return 1
          }
          return 0 // names are equal
        })
      }

      this.addMarkers()

      // only fit to bounds if there are more than one markers
      if (this.markers.length > 0 && !this.config.bounds) {
        this.map.fitToBounds({
          type: 'FeatureCollection',
          features: this.markers
        })
      }
      if (this.markers.length > 0) {
        this.addPopupsList()
      }
    }

    addMarkers () {
      const allowedColours = {
        blue: '#1d70b8',
        green: '#0f7a52',
        orange: '#f47738',
        red: '#ca3535'
      }
      const allowedSymbols = ['circle', 'pin', 'square']
      this.markers.forEach((marker, index) => {
        if (marker.marker) {
          const colour = marker.marker.colour || allowedColours.blue

          if (allowedColours[colour]) {
            marker.marker.backgroundColor = allowedColours[colour]
          } else {
            delete marker.marker.colour
          }

          const symbol = marker.marker.symbol || false
          if (!(symbol && allowedSymbols.includes(symbol))) {
            delete marker.marker.symbol
          }
        }
        const options = Object.assign(Object.assign({}, this.markerOptions), marker.marker || {})
        this.map.addMarker(`marker-${index}`, marker.geometry.coordinates, options)
      })
    }

    addPopupsList () {
      const popupsListWrapper = this.$module.querySelector('.app-c-map__markers-list')
      const popupsListEl = this.$module.querySelector('.js-list-markers ol')

      if (popupsListWrapper && popupsListEl) {
        popupsListWrapper.classList.add('app-c-map__markers-list--visible')
        const popupsList = []
        this.markers.forEach(marker => {
          popupsList.push(this.createPopupContent(marker))
        })
        popupsList.forEach(popup => {
          const listItem = document.createElement('li')
          listItem.innerHTML = popup
          popupsListEl.appendChild(listItem)
        })
      }
    }

    /* istanbul ignore next */
    sendAnalytics (data) {
      if (window.dataLayer && this.trackingEnabled) {
        window.GOVUK.analyticsGa4.core.applySchemaAndSendData(data, 'event_data')
      }
    }
  }
  Modules.Map = Map
})(window.GOVUK.Modules)
