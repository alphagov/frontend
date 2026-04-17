/* global defra */
window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  class Map {
    constructor ($module) {
      this.$module = $module
      this.map_element = this.$module.querySelector('.app-c-map')
      this.map_id = this.$module.getAttribute('id')

      const allMapOptions = {
        centre_lat: 51.505,
        centre_lng: -0.09,
        zoom: 8,
        minZoom: 4
      }
      const passedConfig = JSON.parse(this.$module.getAttribute('data-config')) || {}
      this.config = Object.assign(allMapOptions, passedConfig)

      this.markers = JSON.parse(this.$module.getAttribute('data-markers')) || []
      this.geoJsonUrl = this.$module.getAttribute('data-geojson')
      if (this.geoJsonUrl && !this.geoJsonUrl.startsWith('/')) {
        this.geoJsonUrl = false
      }

      this.markerOptions = {
        symbol: 'circle',
        backgroundColor: '#1d70b8'
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
        mapProvider: defra.maplibreProvider(),
        behaviour: 'hybrid',
        mapLabel: this.config.heading,
        zoom: this.config.zoom,
        minZoom: this.config.minZoom,
        center: [this.config.centre_lng, this.config.centre_lat],
        containerHeight: `${this.config.height}px`,
        mapStyle: {
          url: '/assets/frontend/components/map/liberty',
          // attribution: 'OpenFreeMap © OpenMapTiles Data from OpenStreetMap',
          backgroundColor: '#f5f5f0'
        },
        plugins: [this.interactPlugin]
      })

      this.map.on('map:ready', () => {
        this.addAllMarkers()
      })

      this.map.on('interact:selectionchange', (e) => {
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

      this.map.on('app:panelclosed', (e) => {
        this.interactPlugin.clear()
      })
    }

    createPopupContent (feature) {
      let popupContent = `<span class="app-c-map__popup-title">${this.cleanString(feature.properties.name)}</span>`
      if (feature.properties.description) {
        popupContent = `${popupContent} ${this.cleanString(feature.properties.description)}`
      }
      return popupContent
    }

    cleanString (str) {
      return str.replaceAll('<', '').replaceAll('>', '')
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
          this.addMarkers()
        } catch (error) {
          console.error(`${error}, with geojson at ${this.geoJsonUrl}`)
        }
      } else if (this.markers) {
        this.addMarkers()
      }

      // only fit to bounds if there are more than one markers
      if (this.markers.length > 1) {
        console.log('calling fittobounds')
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
      this.markers.forEach((marker, index) => {
        this.map.addMarker(`marker-${index}`, marker.geometry.coordinates, this.markerOptions)
      })
    }

    addPopupsList () {
      const popupsListWrapper = this.$module.querySelector('.app-c-map__markers-list')
      const popupsListEl = this.$module.querySelector('.js-list-markers ul')

      if (popupsListWrapper && popupsListEl) {
        popupsListWrapper.classList.add('app-c-map__markers-list--visible')
        var popupsList = []
        this.markers.forEach(marker => {
          popupsList.push(this.createPopupContent(marker))
        })
        popupsList.sort()
        popupsList.forEach(popup => {
          const listItem = document.createElement('li')
          listItem.innerHTML = popup
          popupsListEl.appendChild(listItem)
        })
      }
    }
  }
  Modules.Map = Map
})(window.GOVUK.Modules)
