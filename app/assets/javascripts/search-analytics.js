(function() {
  "use strict";

  var root = this,
      $ = root.jQuery;

  if (typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }
  if (typeof root.GOVUK.Search === 'undefined') { root.GOVUK.Search = {}; }

  var extractSearchURLs = function ($searchResults) {
    if ($searchResults.length <= 0) {
      return [];
    }

    function extractSearchURL(index, element) {
      var foundURL = $(element).find('h3 a');

      if (foundURL.parents('.descoped-results').length) {
        return {
          'href': foundURL.attr('href'),
          'scoped': true
        };
      } else {
        return {
          'href': foundURL.attr('href'),
          'scoped': false
        };
      }
    }

    return $searchResults.children().map(extractSearchURL);
  };

  GOVUK.Search.extractSearchURLs = extractSearchURLs;
}).call(this);
