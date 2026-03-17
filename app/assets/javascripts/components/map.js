//= require leaflet

console.log('map');

window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  class Map {
    constructor ($module) {
      this.$module = $module
    }

    init () {
    }

    sanitizeResult (value) {
    }
  }

  Modules.Map = Map
})(window.GOVUK.Modules)
