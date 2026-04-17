/* global L, defra */
window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  class Map {
    constructor ($module) {
      this.$module = $module
      this.map_element = this.$module.querySelector('.app-c-map')
      this.map_id = this.$module.getAttribute('id')
      this.apiKey = this.$module.getAttribute('data-api-key')
      const mapPin = L.icon({
        iconUrl: '/assets/frontend/components/map/marker-pin-hole.svg',
        iconSize: [38, 50],
        iconAnchor: [19, 50],
        popupAnchor: [1, -47]
      })
      const mapCircle = L.icon({
        iconUrl: '/assets/frontend/components/map/marker-circle.svg',
        iconSize: [30, 30],
        iconAnchor: [15, 30],
        popupAnchor: [1, -30]
      })

      const marker = this.$module.getAttribute('data-marker')
      this.markerIcon = marker === 'circle' ? mapCircle : mapPin

      const allMapOptions = {
        centre_lat: 51.505,
        centre_lng: -0.09,
        zoom: 8,
        // minZoom: 7,
        // maxZoom: 16,
        // maxBounds: [
        //   [49.5, -10.5],
        //   [62, 6]
        // ],
        attributionControl: false
      }
      const passedConfig = JSON.parse(this.$module.getAttribute('data-config')) || {}
      this.config = Object.assign(allMapOptions, passedConfig)
      this.markers = JSON.parse(this.$module.getAttribute('data-markers')) || []

      this.geoJsonUrl = this.$module.getAttribute('data-geojson')
      if (this.geoJsonUrl && !this.geoJsonUrl.startsWith('/')) {
        this.geoJsonUrl = false
      }

      this.height = this.$module.getAttribute('data-height')
      this.popups = []
      this.popupsList = []
    }

    init () {
      if (typeof L === 'undefined') return

      if (!this.apiKey) {
        this.$module.innerText = "We're sorry, but the map failed to load. The map API key was not found."
        return
      }
      this.initialiseMap()
    }

    initialiseMap () {
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
        mapLabel: 'FIXME',
        zoom: this.config.zoom,
        center: [this.config.centre_lng, this.config.centre_lat],
        containerHeight: `${this.height}px`,
        mapStyle: {
          url: 'https://tiles.openfreemap.org/styles/liberty',
          attribution: 'OpenFreeMap © OpenMapTiles Data from OpenStreetMap',
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
        console.log('panelclosed', e)
        this.interactPlugin.clear()
      })
    }

    createPopupContent (feature) {
      let popupContent = `<span class="app-c-map__popup-title">${feature.properties.name}</span>`
      if (feature.properties.description) {
        popupContent = `${popupContent} ${feature.properties.description}`
      }
      return popupContent
    }

    addMarkers () {
      this.markers.forEach((marker, index) => {
        this.map.addMarker(`marker-${index}`, marker.geometry.coordinates)
      })
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
      this.interactPlugin.enable()

      if (this.markers.length) {
        console.log('fitting bounds', this.markers)
        this.map.fitToBounds({
          type: 'FeatureCollection',
          features: this.markers
        })
      }
    }
  }
  Modules.Map = Map
})(window.GOVUK.Modules)
