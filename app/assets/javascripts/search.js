$(function() {
  var $searchResults = $('#results .results-list');

  if ($searchResults.length > 0) {
    $('.js-openable-filter').each(function(){
      new GOVUK.CheckboxFilter({el:$(this)});
    })
    GOVUK.liveSearch.init();
  };

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

  (function trackSearchClicks(){
    if($searchResults.length === 0 || !GOVUK.cookie){
      return false;
    }
    $searchResults.on('click', 'a', function(e){
      var $link = $(e.target),
          sublink = '',
          gaParams = ['_setCustomVar', 21, 'searchPosition', '', 3],
          position, href, startAt;

      if($link.closest('ul').hasClass('sections')){
        href = $link.attr('href');
        if(href.indexOf('#') > -1){
          sublink = '&sublink='+href.split('#')[1];
        }
        $link = $link.closest('ul');
      }

      startAt = getStartAtValue();
      position = $link.closest('li').index() + startAt + 1; // +1 so it isn't zero offset

      gaParams[3] = 'position='+position+sublink;
      GOVUK.cookie('ga_nextpage_params', gaParams.join(','));
    });
  }());

  (function trackExternalSearchClicks(){
    if($searchResults.length > 0){
      new GOVUK.TrackExternalLinks($searchResults);
    }
  }());
});
