/* global defra */
/* istanbul ignore next */
window.GOVUK = window.GOVUK || {}
/* istanbul ignore next */
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  class Map {
    constructor ($module) {
      this.$module = $module
      this.map_element = this.$module.querySelector('.app-c-map')
      this.map_id = this.$module.getAttribute('id')
      this.trackingEnabled = this.$module.getAttribute('data-tracking-enabled') === 'true'
      this.headingLevel = parseInt(this.$module.getAttribute('data-heading-level')) || 2
      const cspWorker = this.$module.getAttribute('data-csp-worker')
      this.geoJson = this.$module.getAttribute('data-geojson')
      this.trackingActive = false
      this.panelId = 'the-panel'

      if (this.geoJson) {
        if (!this.geoJson.startsWith('/') && !this.geoJson.startsWith('data:')) {
          console.error('Error: passed geoJSON must be valid and not be an external URL')
          this.geoJson = false
        }
      }

      let datasetsPlugin = false
      if (this.geoJson) {
        datasetsPlugin = defra.datasetsPlugin({
          datasets: [{
            id: 'features',
            geojson: this.geoJson,
            showInMenu: false,
            minZoom: 1,
            maxZoom: 24, // these must exceed the values used by the map config
            style: {
              symbol: 'circle',
              symbolBackgroundColor: '#1d70b8',
              symbolForegroundColor: '#FFFFFF',
              symbolHaloWidth: 3
            }
          }]
        })
      }

      this.interactPlugin = defra.interactPlugin({
        deselectOnClickOutside: true,
        interactionModes: ['selectFeature'],
        layers: [
          { layerId: 'features', idProperty: 'id', labelProperty: 'name' }
        ]
      })

      const config = {
        mapProvider: defra.maplibreProvider({ workerUrl: cspWorker }),
        behaviour: 'inline',
        mapStyle: {
          url: window.GOVUK.mapComponentStyles,
          backgroundColor: '#f5f5f0',
          attribution: ''
        },
        plugins: [this.interactPlugin, datasetsPlugin],
        urlPosition: 'none',
        minZoom: 4,
        maxZoom: 16,
        center: [-0.09, 51.505],
        containerHeight: '500px'
      }
      const passedConfig = JSON.parse(this.$module.getAttribute('data-config')) || {}
      this.config = Object.assign(config, passedConfig)
    }

    init () {
      const id = this.$module.getAttribute('id')
      this.$module.setAttribute('id', '')
      this.map_element.setAttribute('id', id)
      this.map_element.classList.add('app-c-map--enabled')
      this.map = new defra.InteractiveMap(this.map_id, this.config)

      /* istanbul ignore next */
      this.map.on('map:ready', () => {
        this.interactPlugin.enable()
        this.map.addPanel(this.panelId, {
          focus: false,
          label: false,
          showLabel: false,
          html: '<div class="map-panel-content"></div>',
          mobile: { slot: 'drawer', dismissible: true },
          tablet: { slot: 'left-top', dismissible: true, width: '280px' },
          desktop: { slot: 'left-top', dismissible: true, width: '280px' }
        })
        this.map.hidePanel(this.panelId)
        if (this.trackingEnabled) {
          this.trackingActive = true
        }
      })

      /* istanbul ignore next */
      this.map.on('app:panelopened', () => {
        this.panelOpen = true
        this.sendAnalytics({
          event_name: 'select_content',
          type: 'map',
          action: 'opened',
          text: this.currentMarkerName
        })
      })

      /* istanbul ignore next */
      this.map.on('app:panelclosed', () => {
        if (this.panelOpen) {
          this.sendAnalytics({
            event_name: 'select_content',
            type: 'map',
            action: 'closed',
            text: this.currentMarkerName
          })
          this.panelOpen = false
        }
      })

      /* istanbul ignore next */
      this.map.on('interact:selectionchange', (e) => {
        if (!this.panelContent) {
          this.panelContent = this.$module.querySelector('.map-panel-content')
        }

        if (e.selectedFeatures.length > 0) {
          this.currentMarker = e.selectedFeatures[0]
          this.currentMarkerName = this.currentMarker.properties.name
          this.panelContent.innerHTML = this.createPopupContent(this.currentMarker)
          this.map.showPanel(this.panelId)
          this.sendAnalytics({
            event_name: 'select_content',
            type: 'map',
            action: 'markerClick',
            text: this.currentMarkerName
          })
        } else {
          this.map.hidePanel(this.panelId)
        }
      })

      /* istanbul ignore next */
      this.map.on('app:panelclosed', (e) => {
        this.interactPlugin.clear()
      })
    }

    createPopupContent (feature) {
      const heading = `h${this.headingLevel}`
      let popupContent = `<${heading} class="govuk-heading-s govuk-!-margin-bottom-2">${feature.properties.name}</${heading}>`

      const keys = Object.keys(feature.properties)
      keys.forEach((key) => {
        if (key !== 'name') {
          popupContent = `${popupContent} <p class="govuk-body govuk-!-margin-bottom-2">${feature.properties[key]}</p>`
        }
      })
      popupContent = this.removeScript(popupContent)
      return popupContent
    }

    removeScript (input) {
      do {
        input = input.replace(/<[\s]*script/g, '')
      } while (input.includes('<script'))
      return input
    }

    /* istanbul ignore next */
    sendAnalytics (data) {
      if (window.dataLayer && this.trackingActive) {
        window.GOVUK.analyticsGa4.core.applySchemaAndSendData(data, 'event_data')
      }
    }
  }
  Modules.Map = Map
})(window.GOVUK.Modules)
