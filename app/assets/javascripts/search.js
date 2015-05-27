(function() {
  "use strict";

  window.GOVUK = window.GOVUK || {};

  var $ = window.jQuery;

  var search = {
    init: function () {
      var $searchResults = $('#results .results-list');

      search.enableLiveSearchCheckbox($searchResults);
      search.trackExternalSearchClicks($searchResults);
      search.trackSearchClicks($searchResults);
      search.trackSpellingSuggestions();
    },
    enableLiveSearchCheckbox: function ($searchResults) {
      if ($searchResults.length > 0) {
        $('.js-openable-filter').each(function(){
          new GOVUK.CheckboxFilter({el:$(this)});
        });
        GOVUK.liveSearch.init();
      };
    },
    extractSearchURLs: function ($searchResults) {
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
    },
    trackExternalSearchClicks: function ($searchResults) {
      if ($searchResults.length > 0) {
        new GOVUK.TrackExternalLinks($searchResults);
      }
    },
    trackSearchClicks: function ($searchResults) {
      if($searchResults.length === 0 || !GOVUK.cookie){
        return;
      }

      $searchResults.on('click', 'a', function(e){
        var $link = $(e.target),
            sublink = '',
            position, href, startAt;

        var getStartAtValue = function() {
          var queryString = window.location.search,
              startAtRegex = /(&|\?)start=([0-9]+)(&|$)/,
              startAt = 0,
              matches;

          matches = queryString.match(startAtRegex);

          if (matches !== null) {
            startAt = parseInt(matches[2], 10);
          }

          return startAt;
        };

        if ($link.closest('ul').hasClass('sections')) {
          href = $link.attr('href');

          if (href.indexOf('#') > -1) {
            sublink = '&sublink='+href.split('#')[1];
          }

          $link = $link.closest('ul');
        }

        startAt = getStartAtValue();
        position = $link.closest('li').index() + startAt + 1; // +1 so it isn't zero offset
        GOVUK.analytics.callOnNextPage('setSearchPositionDimension', 'position=' + position + sublink);
      });
    },
    trackSearchResultURLs: function () {
      var searchURLs = search.extractSearchURLs($searchResults);

      if (searchURLs.length) {
        GOVUK.analytics.trackEvent('Search Results', 'Shown', {
          label: searchURLs,
          nonInteraction: true
        });
      }
    },
    trackSpellingSuggestions: function () {
      var $spellingSuggestion = $('.spelling-suggestion a');

      if ($spellingSuggestion.length) {
        GOVUK.analytics.trackEvent('Search suggestions', 'Shown', {
          label: $spellingSuggestion.text(),
          nonInteraction: true
        });
      }
    }
  };

  GOVUK.search = search;
  GOVUK.search.init();
}).call(this);
