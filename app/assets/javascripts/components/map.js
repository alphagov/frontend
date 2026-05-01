/* global defra */
window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  class Map {
    constructor ($module) {
      this.$module = $module
      this.map_element = this.$module.querySelector('.app-c-map')
      this.map_id = this.$module.getAttribute('id')
      this.csp_worker = this.$module.getAttribute('data-csp-worker')
      this.config = {
        centre_lat: 51.505,
        centre_lng: -0.09,
        zoom: 8,
        minZoom: 4,
        maxZoom: 16
      }
      const passedConfig = JSON.parse(this.$module.getAttribute('data-config')) || {}
      this.config = Object.assign(this.config, passedConfig)

      this.markers = JSON.parse(this.$module.getAttribute('data-markers')) || []
      this.geoJsonUrl = this.$module.getAttribute('data-geojson')
      if (this.geoJsonUrl && !this.geoJsonUrl.startsWith('/')) {
        console.error(`Error: external URLs for geoJSON are not allowed: ${this.geoJsonUrl}`)
        this.geoJsonUrl = false
      }
      this.headingLevel = parseInt(this.$module.getAttribute('data-heading-level')) || 2

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

      this.interactPlugin = defra.interactPlugin({
        deselectOnClickOutside: true
      })

      this.map = new defra.InteractiveMap(this.map_id, {
        mapProvider: defra.maplibreProvider({ workerUrl: this.csp_worker }),
        behaviour: 'hybrid',
        mapLabel: this.config.heading,
        zoom: this.config.zoom,
        minZoom: this.config.minZoom,
        maxZoom: this.config.maxZoom,
        center: [this.config.centre_lng, this.config.centre_lat],
        containerHeight: `${this.config.height}px`,
        bounds: this.config.bounds,
        mapStyle: {
          url: window.GOVUK.mapComponentStyles,
          // attribution: 'OpenFreeMap © OpenMapTiles Data from OpenStreetMap',
          backgroundColor: '#f5f5f0'
        },
        plugins: [this.interactPlugin],
        urlPosition: 'none'
      })

      /* istanbul ignore next */
      this.map.on('map:ready', () => {
        this.addAllMarkers()
      })

      this.map.on('interact:selectionchange', (e) => {
        /* istanbul ignore next */
        if (e.selectedMarkers.length > 0) {
          var marker = parseInt(e.selectedMarkers[0].replace('marker-', ''))
          marker = this.markers[marker]
          this.map.addPanel('the-panel', {
            focus: false,
            label: marker.name,
            html: this.createPopupContent(marker),
            mobile: { slot: 'drawer', dismissible: true },
            tablet: { slot: 'left-top', dismissible: true, width: '280px' },
            desktop: { slot: 'left-top', dismissible: true, width: '280px' }
          })
        } else {
          this.map.hidePanel('the-panel')
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
        popupContent = `${popupContent} ${feature.properties.description}`
      }
      return popupContent
    }

    async addAllMarkers () {
      if (this.geoJsonUrl) {
        try {
          const response = await fetch(this.geoJsonUrl)
          if (!response.ok) {
            throw new Error(`Response status: ${response.status}`)
          }
          const result = await response.json()
          if (this.markers) {
            this.markers = this.markers.concat(result.features)
          }
        } catch (error) {
          console.error(`${error}, with geojson at ${this.geoJsonUrl}`)
        }
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
      this.addMarkers()

      // only fit to bounds if there are more than one markers
      if (this.markers.length > 0 && !this.config.bounds) {
        this.map.fitToBounds({
          type: 'FeatureCollection',
          features: this.markers
        })
      }
      if (this.markers.length > 0) {
        this.interactPlugin.enable()
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
          const colour = marker.marker.colour || false
          if (colour) {
            if (allowedColours[colour]) {
              marker.marker.backgroundColor = allowedColours[colour]
            }
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
        var popupsList = []
        this.markers.forEach(marker => {
          popupsList.push(this.createPopupContent(marker))
        })
        popupsList.forEach(popup => {
          const listItem = document.createElement('li')
          // listItem.appendChild(popup)
          listItem.innerHTML = popup
          popupsListEl.appendChild(listItem)
        })
      }
    }
  }
  Modules.Map = Map
})(window.GOVUK.Modules)
