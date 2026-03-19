//= require leaflet
window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  class Map {
    constructor ($module) {
      this.$module = $module
      this.map_id = this.$module.getAttribute('id')
      this.apiKey = this.$module.getAttribute('data-api-key')
      const passed_config = JSON.parse(this.$module.getAttribute('data-config')) || {}
      const all_map_options = {
        centre_lat: 51.505,
        centre_lng: -0.09,
        zoom: 8,
        minZoom: 7,
        maxZoom: 16,
        maxBounds: [
          [49.5, -10.5],
          [62, 6]
        ],
      }
      this.config = window.GOVUK.extendObject(all_map_options, passed_config)
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
      // console.log('initialising', this.map_id, this.config)

      this.map = L.map(this.map_id, this.config)
      this.map.setView([this.config.centre_lat, this.config.centre_lng], this.config.zoom);

      // // Load and display ZXY tile layer on the map
      const basemap = L.tileLayer(`https://api.os.uk/maps/raster/v1/zxy/Light_3857/{z}/{x}/{y}.png?key=${this.apiKey}`)
      basemap.addTo(this.map)
    }

    addMarkers () {
      console.log('addMarkers')
      var default_icon = L.icon({
        iconUrl: '/assets/frontend/components/default_marker.png',
        iconSize:     [30, 50], // size of the icon
        iconAnchor:   [15, 50], // point of the icon which will correspond to marker's location
        popupAnchor:  [0, -48] // point from which the popup should open relative to the iconAnchor
      })

      L.marker([51.5, -0.09], {icon: default_icon}).addTo(this.map)
      var marker = L.marker([51.5, -0.09]).addTo(this.map);

      for (var i = 0; i < this.markers.length; i++) {
        const mark = this.markers[i]
        console.log(mark)
        const marker = L.marker([mark.lat, mark.lng], {icon: default_icon}).addTo(this.map)
        marker.bindPopup(mark.popup_content)
      }

    }
  }
  Modules.Map = Map
})(window.GOVUK.Modules)
