/* global L */
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
        minZoom: 7,
        maxZoom: 16,
        maxBounds: [
          [49.5, -10.5],
          [62, 6]
        ],
        attributionControl: false
      }
      const passedConfig = JSON.parse(this.$module.getAttribute('data-config')) || {}
      this.config = Object.assign(allMapOptions, passedConfig)
      this.markers = JSON.parse(this.$module.getAttribute('data-markers'))

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
      this.addAllMarkers()
    }

    initialiseMap () {
      const id = this.$module.getAttribute('id')
      this.$module.setAttribute('id', '')
      this.map_element.setAttribute('id', id)
      this.map_element.classList.add('app-c-map--enabled')
      if (this.height) { this.map_element.style.height = `${this.height}px` }

      this.map = L.map(this.map_id, this.config)
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
      this.map.setView([this.config.centre_lat, this.config.centre_lng], this.config.zoom)

      // Load and display ZXY tile layer on the map
      const basemap = L.tileLayer(`https://api.os.uk/maps/raster/v1/zxy/Light_3857/{z}/{x}/{y}.png?key=${this.apiKey}`)
      basemap.addTo(this.map)
    }

    createMarker (feature, latlng) {
      const marker = L.marker(latlng, { alt: feature.properties.name, icon: this.markerIcon })
      this.popups.push(marker)

      const popupContent = this.createPopupContent(feature)
      this.popupsList.push(popupContent)
      return marker
    }

    createPopupContent (feature) {
      let popupContent = `<span class="app-c-map__popup-title">${feature.properties.name}</span>`
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
          L.geoJSON(result, {
            pointToLayer: (feature, latlng) => {
              return this.createMarker(feature, latlng)
            },
            onEachFeature: (feature, layer) => {
              layer.bindPopup(this.createPopupContent(feature), { maxWidth: 200 })
            }
          }).addTo(this.map)
        } catch (error) {
          console.error(`${error}, with geojson at ${this.geoJsonUrl}`)
        }
      }

      if (this.markers) {
        this.markers.forEach(feature => {
          const marker = this.createMarker(feature, [feature.lat, feature.lng])
          marker.addTo(this.map)
          marker.bindPopup(this.createPopupContent(feature), { maxWidth: 200 })
        })
      }

      if (this.popups.length) {
        const group = new L.FeatureGroup(this.popups)
        this.map.fitBounds(group.getBounds(), { padding: [20, 20] })

        const popupsListWrapper = this.$module.querySelector('.app-c-map__markers-list')
        const popupsListEl = this.$module.querySelector('.js-list-markers ul')

        if (popupsListWrapper && popupsListEl) {
          popupsListWrapper.classList.add('app-c-map__markers-list--visible')
          this.popupsList.sort()
          this.popupsList.forEach(popup => {
            const listItem = document.createElement('li')
            listItem.innerHTML = popup
            popupsListEl.appendChild(listItem)
          })
        }
      }
    }
  }
  Modules.Map = Map
})(window.GOVUK.Modules)
