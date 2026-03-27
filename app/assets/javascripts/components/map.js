/* global L */
//= require leaflet
window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  /* istanbul ignore next */
  class Map {
    constructor ($module) {
      this.$module = $module
      this.map_element = this.$module.querySelector('.app-c-map')
      this.map_id = this.$module.getAttribute('id')
      this.apiKey = this.$module.getAttribute('data-api-key')
      const mapPin = L.icon({
        iconUrl: '/assets/frontend/components/map/marker-pin-hole.svg',
        iconSize: [38, 50], // size of the icon
        iconAnchor: [19, 50], // point of the icon which will correspond to marker's location
        popupAnchor: [1, -47] // point from which the popup should open relative to the iconAnchor
      })
      const mapCircle = L.icon({
        iconUrl: '/assets/frontend/components/map/marker-circle.svg',
        iconSize: [30, 30], // size of the icon
        iconAnchor: [15, 30], // point of the icon which will correspond to marker's location
        popupAnchor: [1, -30] // point from which the popup should open relative to the iconAnchor
      })

      const marker = this.$module.getAttribute('data-marker')
      this.markerIcon = marker === 'circle' ? mapCircle : mapPin

      const allMapOptions = {
        centre_lat: 51.505,
        centre_lng: -0.09,
        zoom: 8,
        minZoom: 7,
        maxZoom: 16,
        maxBounds: [
          [49.5, -10.5],
          [62, 6]
        ],
        attributionControl: false
      }
      const passedConfig = JSON.parse(this.$module.getAttribute('data-config')) || {}
      this.config = window.GOVUK.extendObject(allMapOptions, passedConfig)
      this.markers = JSON.parse(this.$module.getAttribute('data-markers'))
      this.geoJsonUrl = this.$module.getAttribute('data-geojson')
    }

    init () {
      if (!this.apiKey) {
        this.$module.innerText = "We're sorry, but the map failed to load. Please try reloading the page."
        return
      }
      this.initialiseMap()
      this.addAllMarkers()
    }

    initialiseMap () {
      const id = this.$module.getAttribute('id')
      this.$module.setAttribute('id', '')
      this.map_element.setAttribute('id', id)
      this.map_element.classList.add('app-c-map--enabled')

      this.map = L.map(this.map_id, this.config)
      this.map.setView([this.config.centre_lat, this.config.centre_lng], this.config.zoom)

      // Load and display ZXY tile layer on the map
      const basemap = L.tileLayer(`https://api.os.uk/maps/raster/v1/zxy/Light_3857/{z}/{x}/{y}.png?key=${this.apiKey}`)
      basemap.addTo(this.map)
    }

    async addAllMarkers () {
      this.popups = []

      try {
        if (this.geoJsonUrl) {
          const response = await fetch(this.geoJsonUrl)
          if (!response.ok) {
            throw new Error(`Response status: ${response.status}`)
          }
          const result = await response.json()
          const that = this
          /* istanbul ignore next */
          L.geoJSON(result, {
            pointToLayer: function (feature, latlng) {
              const marker = L.marker(latlng, { icon: that.markerIcon })
              that.popups.push(marker)
              return marker
            },
            onEachFeature: function (feature, layer) {
              if (feature.properties.popupContent) {
                layer.bindPopup(feature.properties.popupContent, { maxWidth: 200 })
              }
            }
          }).addTo(this.map)
        }
      } catch (error) {
        console.error(`${error}, could not access geojson at ${this.geoJsonUrl}`)
      }

      if (this.markers.length) {
        this.markers.forEach(marker => {
          const popup = L.marker([marker.lat, marker.lng], { alt: marker.alt, icon: this.markerIcon })
          this.popups.push(popup)
          popup.addTo(this.map)
          if (marker.popupContent) {
            popup.bindPopup(marker.popupContent, { maxWidth: 200 })
          }
        })
      }

      /* istanbul ignore next */
      if (this.popups.length) {
        const group = new L.FeatureGroup(this.popups)
        this.map.fitBounds(group.getBounds())
      }
    }
  }
  Modules.Map = Map
})(window.GOVUK.Modules)
