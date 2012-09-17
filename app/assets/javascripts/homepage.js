// Homepage manifest
//= require_self
function initSuggestions() {
  var $li = $('#homepage-search-suggestion').find('li');
  var i = Math.floor(Math.random() * $li.length);
  $li.hide().eq(i).show();
  setInterval(function() { cycleSuggestion(); }, 12000);
}

function cycleSuggestion() {
  var $li = $('#homepage-search-suggestion').find('li:visible').fadeOut(800, function() {
    $(this).next().fadeIn(800);
    if ($(this).next().length < 1) {
      $(this).siblings().first().fadeIn(800);
    }
  });
}

/*
* Set up Google analytics event tracking for homepage analysis
*/
function initAnalytics() {
  // Search Suggestions
  $('.search-suggestions').on('click', 'a', function (e) {
    if ( _gat && _gat._getTracker ) {
      _gaq.push(['_trackEvent', 'homepage_analysis', 'search_suggestion', this.href]);
    }
  });

  // Browse sections
  $('.homepage-sections').on('click', 'h2 a', function (e) {
    if ( _gat && _gat._getTracker ) {
      _gaq.push(['_trackEvent', 'homepage_analysis', 'nav_links', this.href]);
    }
  }).on('click', '.sections-links a', function (e) {
    if ( _gat && _gat._getTracker ) {
      _gaq.push(['_trackEvent', 'homepage_analysis', 'page_links', this.href]);
    }
  });
}

$(document).ready(function() {
  initSuggestions();
  initAnalytics();
});
