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
        iconUrl: '/assets/frontend/components/default_marker.png',
        // shadowUrl: 'leaf-shadow.png',
        iconSize: [30, 50], // size of the icon
        // shadowSize: [50, 64], // size of the shadow
        iconAnchor: [15, 50], // point of the icon which will correspond to marker's location
        // shadowAnchor: [4, 62], // the same for the shadow
        popupAnchor: [0, -48] // point from which the popup should open relative to the iconAnchor
      })

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
        ],
        attributionControl: false
      }
      this.config = window.GOVUK.extendObject(allMapOptions, passedConfig)
      this.markers = JSON.parse(this.$module.getAttribute('data-markers')) || []
      this.geojson = this.$module.getAttribute('data-geojson')
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
      if (this.geojson) {
        this.addMarkersFromGeoJson()
      }
    }

    initialiseMap () {
      const id = this.$module.getAttribute('id')
      this.$module.setAttribute('id', '')
      this.map_element.setAttribute('id', id)
      this.map_element.classList.add('app-c-map--enabled')

      this.map = L.map(this.map_id, this.config)
      this.map.setView([this.config.centre_lat, this.config.centre_lng], this.config.zoom)

      // // Load and display ZXY tile layer on the map
      const basemap = L.tileLayer(`https://api.os.uk/maps/raster/v1/zxy/Light_3857/{z}/{x}/{y}.png?key=${this.apiKey}`)
      basemap.addTo(this.map)
    }

    addMarkers () {
      var popups = []
      this.markers.forEach(marker => {
        const popup = L.marker([marker.lat, marker.lng], { alt: marker.alt, icon: this.markerIcon })
        popups.push(popup)
        popup.addTo(this.map)
        if (marker.popup_content) {
          popup.bindPopup(marker.popup_content, { maxWidth: 200 })
        }
      })

      const group = new L.FeatureGroup(popups)
      this.map.fitBounds(group.getBounds())
    }

    addMarkersFromGeoJson () {
      async function getData(url, that) {
        try {
          const response = await fetch(url);
          if (!response.ok) {
            throw new Error(`Response status: ${response.status}`)
          }
          const result = await response.json()
          var popups = []

          L.geoJSON(result, {
            pointToLayer: function (feature, latlng) {
              const marker = L.marker(latlng, { icon: that.markerIcon })
              popups.push(marker)
              return marker
            },
            onEachFeature: function (feature, layer) {
              layer.bindPopup(feature.properties.popupContent, { maxWidth: 200 })
            }
          }).addTo(that.map)

          const group = new L.FeatureGroup(popups)
          that.map.fitBounds(group.getBounds())
        } catch (error) {
          console.error(error)
        }
      }
      getData(this.geojson, this)
    }


    bindPopup (feature, layer) {
      const featureProperties = layer.feature.properties
      const geometryType = layer.feature.geometry.type
      const layerPane = layer.options.pane

      const popupContainer = this.context.createAndPopulateElement('div', null, null)
      const getHeadingAndPropVals = this.context.getHeadingAndProp(geometryType, featureProperties, layerPane)

      popupContainer.appendChild(this.context.createPopupHeading(getHeadingAndPropVals[0]))
      popupContainer.appendChild(this.context.createPopupBody(getHeadingAndPropVals[1], featureProperties))

      const popup = layer.bindPopup(popupContainer, { maxWidth: 250 })
      popup.on('popupopen', (e) => {
        const popup = e.target.getPopup()
        const content = popup.getContent()
        /* istanbul ignore next */
        const extraAttributes = {
          action: 'opened',
          text: content.querySelector('.map-popup__heading').innerText.trim() || ''
        }
        this.context.sendTracking(extraAttributes)
      })
    }
  }
  Modules.Map = Map
})(window.GOVUK.Modules)
