/* global L */
//= require leaflet
window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  class Map {
    constructor ($module) {
      this.$module = $module
      this.map_id = this.$module.getAttribute('id')
      this.apiKey = this.$module.getAttribute('data-api-key')
      const passedConfig = JSON.parse(this.$module.getAttribute('data-config')) || {}
      const allMapOptions = {
        centre_lat: 51.505,
        centre_lng: -0.09,
        zoom: 8,
        minZoom: 7,
        maxZoom: 16,
        maxBounds: [
          [49.5, -10.5],
          [62, 6]
        ]
      }
      this.config = window.GOVUK.extendObject(allMapOptions, passedConfig)
      this.markers = JSON.parse(this.$module.getAttribute('data-markers')) || []
    }

    init () {
      if (!this.apiKey) {
        this.$module.innerText = "We're sorry, but the map failed to load. Please try reloading the page."
        return
      }
      this.initialiseMap()
      if (this.markers.length > 0) {
        this.addMarkers()
      }
    }

    initialiseMap () {
      this.$module.classList.add('app-c-map--enabled')
      this.map = L.map(this.map_id, this.config)
      this.map.setView([this.config.centre_lat, this.config.centre_lng], this.config.zoom)

      // // Load and display ZXY tile layer on the map
      const basemap = L.tileLayer(`https://api.os.uk/maps/raster/v1/zxy/Light_3857/{z}/{x}/{y}.png?key=${this.apiKey}`)
      basemap.addTo(this.map)
    }

    addMarkers () {
      var defaultIcon = L.icon({
        iconUrl: '/assets/frontend/components/default_marker.png',
        // shadowUrl: 'leaf-shadow.png',
        iconSize: [30, 50], // size of the icon
        // shadowSize: [50, 64], // size of the shadow
        iconAnchor: [15, 50], // point of the icon which will correspond to marker's location
        // shadowAnchor: [4, 62], // the same for the shadow
        popupAnchor: [0, -48] // point from which the popup should open relative to the iconAnchor
      })

      var popups = []
      this.markers.forEach(marker => {
        const popup = L.marker([marker.lat, marker.lng], { icon: defaultIcon })
        popups.push(popup)
        popup.addTo(this.map)
        popup.bindPopup(marker.popup_content)
      })

      const group = new L.FeatureGroup(popups)
      this.map.fitBounds(group.getBounds())
    }
  }
  Modules.Map = Map
})(window.GOVUK.Modules)
