(function() {
  "use strict";

  window.GOVUK = window.GOVUK || {};

  var liveSearch = {
    action: false,
    state: false,
    resultCache: {},

    $form: false,
    $results: false,
    $resultCount: false,

    init: function(){
      if(GOVUK.support.history()){
        liveSearch.$form = $('.js-live-search-form');
        if(liveSearch.$form){
          liveSearch.$results = $('#js-live-search-results');
          liveSearch.$resultCount = $('#js-live-search-result-count');

          liveSearch.action = liveSearch.$form.attr('action') + '.json';

          liveSearch.saveInitalState();

          liveSearch.$form.on('change', 'input[type=checkbox]', liveSearch.checkboxChange);
          $(window).on('popstate', liveSearch.popState);
        }
      }
    },
    popState: function(event){
      liveSearch.state = event.originalEvent.state;
      liveSearch.updateResults();
    },
    checkboxChange: function(){
      if(liveSearch.isNewState()){
        liveSearch.saveState();
        liveSearch.updateResults();
      }
    },
    saveInitalState: function(){
      liveSearch.saveState();
      var count = liveSearch.$resultCount.text().match(/^\s*([0-9]+)/);
      liveSearch.resultCache[liveSearch.state] = {
        result_count: count ? count[1] : '',
        results: liveSearch.$results.html()
      };
    },
    isNewState: function(){
      return liveSearch.state !== liveSearch.$form.serialize();
    },
    saveState: function(){
      liveSearch.state = liveSearch.$form.serialize();
    },
    updateResults: function(){
      if(typeof liveSearch.resultCache[liveSearch.state] === 'undefined'){
        liveSearch.showLoadingIndicator();
        $.ajax({
          url: liveSearch.action,
          data: liveSearch.state,
        }).done(function(response){
          liveSearch.resultCache[liveSearch.state] = response;
          liveSearch.displayResults();
          liveSearch.hideLoadingIndicator();
        });
      } else {
        liveSearch.displayResults();
      }
    },
    showLoadingIndicator: function(){
      liveSearch._resultCountText = liveSearch.$resultCount.text();
      liveSearch.$resultCount.text('Loading...');
    },
    hideLoadingIndicator: function(){
      liveSearch.$resultCount.text(liveSearch._resultCountText);
    },
    displayResults: function(){
      var results = liveSearch.resultCache[liveSearch.state];
      history.pushState(liveSearch.state, '', window.location.pathname + "?" + liveSearch.state);

      liveSearch.$resultCount.text(results.result_count + ' found on GOV.UK');
      liveSearch.$results.html(results.results);
    }
  };
  GOVUK.liveSearch = liveSearch;
}());
