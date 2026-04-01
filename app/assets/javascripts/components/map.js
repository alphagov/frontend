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
      // const mapPin = L.icon({
      //   iconUrl: '/assets/frontend/components/map/marker-pin-hole.svg',
      //   iconSize: [38, 50],
      //   iconAnchor: [19, 50],
      //   popupAnchor: [1, -47]
      // })
      // const mapCircle = L.icon({
      //   iconUrl: '/assets/frontend/components/map/marker-circle.svg',
      //   iconSize: [30, 30],
      //   iconAnchor: [15, 30],
      //   popupAnchor: [1, -30]
      // })

      // const marker = this.$module.getAttribute('data-marker')
      // this.markerIcon = marker === 'circle' ? mapCircle : mapPin

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
      this.height = this.$module.getAttribute('data-height')
    }

    init () {
      // if (typeof L === 'undefined') return

      // if (!this.apiKey) {
      //   this.$module.innerText = "We're sorry, but the map failed to load. The map API key was not found."
      //   return
      // }
      this.initialiseMap()
      // this.addAllMarkers()
    }

    initialiseMap () {
      const id = this.$module.getAttribute('id')
      this.$module.setAttribute('id', '')
      this.map_element.setAttribute('id', id)
      this.map_element.classList.add('app-c-map--enabled')
      // if (this.height) { this.map_element.style.height = `${this.height}px` }

      // const interactiveMap = new defra.InteractiveMap(this.map_id, {
      //   mapProvider: defra.maplibreProvider(),
      //   behaviour: 'hybrid',
      //   mapLabel: 'Ambleside',
      //   zoom: 14,
      //   center: [-2.968, 54.425],
      //   containerHeight: '650px',
      //   mapStyle: {
      //     url: 'https://tiles.openfreemap.org/styles/liberty',
      //     attribution: 'OpenFreeMap © OpenMapTiles Data from OpenStreetMap',
      //     backgroundColor: '#f5f5f0'
      //   }
      // })

      new defra.InteractiveMap(this.map_id, {
        mapProvider: defra.maplibreProvider(),
        behaviour: 'inline',
        mapStyle: {},
        center: [-1.6, 53.1],
        zoom: 6,
        containerHeight: '500px',
        enableZoomControls: true,
      })

      // this.map = L.map(this.map_id, this.config)
      // this.map.setView([this.config.centre_lat, this.config.centre_lng], this.config.zoom)

      // Load and display ZXY tile layer on the map
      // const basemap = L.tileLayer(`https://api.os.uk/maps/raster/v1/zxy/Light_3857/{z}/{x}/{y}.png?key=${this.apiKey}`)
      // basemap.addTo(this.map)
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
          L.geoJSON(result, {
            pointToLayer: function (feature, latlng) {
              const marker = L.marker(latlng, { alt: feature.properties.name, icon: that.markerIcon })
              that.popups.push(marker)
              return marker
            },
            onEachFeature: function (feature, layer) {
              if (feature.properties.description) {
                layer.bindPopup(`<strong>${feature.properties.name}</strong><br>${feature.properties.description}`, { maxWidth: 200 })
              }
            }
          }).addTo(this.map)
        }
      } catch (error) {
        console.error(`${error}, could not access geojson at ${this.geoJsonUrl}`)
      }

      if (this.markers) {
        this.markers.forEach(marker => {
          const popup = L.marker([marker.lat, marker.lng], { alt: marker.name, icon: this.markerIcon })
          this.popups.push(popup)
          popup.addTo(this.map)

          /* istanbul ignore next */
          if (marker.description) {
            popup.bindPopup(`<strong>${marker.name}</strong><br>${marker.description}`, { maxWidth: 200 })
          }
        })
      }

      if (this.popups.length) {
        const group = new L.FeatureGroup(this.popups)
        this.map.fitBounds(group.getBounds(), { padding: [20, 20] })

        const popupsListEl = this.$module.querySelector('.js-list-markers ul')
        if (popupsListEl) {
          this.popups.forEach(popup => {
            const listItem = document.createElement('li')
            listItem.innerHTML = popup.options.alt
            popupsListEl.appendChild(listItem)
          })
        }
      }
    }
  }
  Modules.Map = Map
})(window.GOVUK.Modules)
