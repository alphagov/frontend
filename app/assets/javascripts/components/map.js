/* global L */
//= require leaflet
window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  class Map {
    constructor ($module) {
      this.$module = $module
      this.map_element = this.$module.querySelector('.app-c-map')
      this.map_id = this.$module.getAttribute('id')
      this.apiKey = this.$module.getAttribute('data-api-key')
      this.markerIcon = L.icon({
        iconUrl: '/assets/frontend/components/map/map-pin.svg',
        iconSize: [34, 46], // size of the icon
        iconAnchor: [17, 46], // point of the icon which will correspond to marker's location
        popupAnchor: [0, -42] // point from which the popup should open relative to the iconAnchor
      })

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
      try {
        var popups = []

        if (this.geoJsonUrl) {
          const response = await fetch(this.geoJsonUrl)
          if (!response.ok) {
            throw new Error(`Response status: ${response.status}`)
          }
          const result = await response.json()
          const markerIcon = this.markerIcon
          L.geoJSON(result, {
            pointToLayer: function (feature, latlng) {
              const marker = L.marker(latlng, { icon: markerIcon })
              popups.push(marker)
              return marker
            },
            onEachFeature: function (feature, layer) {
              if (feature.properties.popupContent) {
                layer.bindPopup(feature.properties.popupContent, { maxWidth: 200 })
              }
            }
          }).addTo(this.map)
        }

        if (this.markers.length) {
          this.markers.forEach(marker => {
            const popup = L.marker([marker.lat, marker.lng], { alt: marker.alt, icon: this.markerIcon })
            popups.push(popup)
            popup.addTo(this.map)
            if (marker.popupContent) {
              popup.bindPopup(marker.popupContent, { maxWidth: 200 })
            }
          })
        }

        if (popups.length) {
          const group = new L.FeatureGroup(popups)
          this.map.fitBounds(group.getBounds())
        }
      } catch (error) {
        console.error(error)
      }
    }
  }
  Modules.Map = Map
})(window.GOVUK.Modules)
