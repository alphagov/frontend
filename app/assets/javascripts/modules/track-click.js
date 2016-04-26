window.GOVUK.Modules = window.GOVUK.Modules || {};

(function(Modules) {
  "use strict";

  Modules.TrackClick = function () {
    this.start = function (element) {
      element.on('click', trackClick);

      var options = {},
          category = element.data('track-category'),
          action = element.data('track-action'),
          label = element.data('track-label');

      if (label) {
        options.label = label;
      }

      function trackClick() {
        if (GOVUK.analytics && GOVUK.analytics.trackEvent) {
          GOVUK.analytics.trackEvent(category, action, options);
        }
      }
    };
  };
})(window.GOVUK.Modules);
