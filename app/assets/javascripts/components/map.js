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
      this.addAllMarkers()
    }

    initialiseMap () {
      const id = this.$module.getAttribute('id')
      this.$module.setAttribute('id', '')
      this.map_element.setAttribute('id', id)
      this.map_element.classList.add('app-c-map--enabled')

      this.map = new defra.InteractiveMap(this.map_id, {
        mapProvider: defra.maplibreProvider(),
        behaviour: 'inline',
        center: [this.config.centre_lng, this.config.centre_lat],
        zoom: 11,
        containerHeight: `${this.height}px`,
        enableZoomControls: true,
        mapStyle: {
          url: 'https://tiles.openfreemap.org/styles/liberty',
          attribution: '© OpenStreetMap contributors',
          // appColorScheme: 'dark'
          mapColorScheme: 'dark'
        },
        plugins: [
          // createSearchPlugin(),
          defra.interactPlugin({
            interactionMode: 'select'
          })
        ],
      })

      this.map.on('app:ready', () => {
        console.log('Map is ready')
      })

      // this.map.on('map:click', (event) => {
      //   console.log('click', event)
      //   this.map.showPanel('info-panel')
      // })

      this.map.on('map:ready', ({ map, mapStyleId, mapSize }) => {
        console.log('Active style:', mapStyleId, 'Size:', mapSize)

        this.map.addPanel('info-panel', {
          label: 'Information',
          html: '<p>Panel content here</p>',
          mobile: { slot: 'drawer' },
          tablet: { slot: 'left-top' },
          desktop: { slot: 'left-top' }
        })

        this.map.addMarker("PaddingtonStation", [-0.1766, 51.5163], {
          shape: 'pin',
          panelId: 'info-panel',
          onClick: (event, context) => console.log('Clicked'),
        })

        this.map.on('interact:done', (e) => {
          console.log(e)
          if (e.coords) {
            console.log('Location selected:', e.coords)
          }
          if (e.selectedFeatures) {
            console.log('Features selected:', e.selectedFeatures)
          }
        })
      })
    }

    async addAllMarkers () {
      console.log(this.markers)

      // let marker = new Marker()
      //   .setLngLat([30.5, 50.5])
      //   .addTo(this.map);
      // this.map.addMarker("Paddington Station", [-0.1766, 51.5163], { shape: 'pin', panelId: "test" })

      this.popups = []

      return
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
