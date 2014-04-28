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
      } else {
        $('.js-live-search-fallback').show();
      }
    },
    popState: function(event){
      liveSearch.state = event.originalEvent.state;
      liveSearch.updateResults();
      liveSearch.restoreCheckboxes();
      liveSearch.pageTrack();
    },
    pageTrack: function(){
      if(window._gaq && _gaq.push){
        _gaq.push(["_setCustomVar",5,"ResultCount",liveSearch.cache().result_count,3]);
        _gaq.push(['_trackPageview']);
      }
    },
    checkboxChange: function(){
      var pageUpdated;
      if(liveSearch.isNewState()){
        liveSearch.saveState();
        pageUpdated = liveSearch.updateResults();
        pageUpdated.done(function(){
          history.pushState(liveSearch.state, '', window.location.pathname + "?" + $.param(liveSearch.state));
          liveSearch.pageTrack();
        });
      }
    },
    cache: function(data){
      if(typeof data === 'undefined'){
        return liveSearch.resultCache[$.param(liveSearch.state)];
      } else {
        liveSearch.resultCache[$.param(liveSearch.state)] = data;
      }
    },
    saveInitalState: function(){
      liveSearch.saveState();
      var count = liveSearch.$resultCount.text().match(/^\s*([0-9]+)/);
      liveSearch.cache({
        result_count: count ? count[1] : '',
        results: liveSearch.$results.html()
      });
    },
    isNewState: function(){
      return $.param(liveSearch.state) !== liveSearch.$form.serialize();
    },
    saveState: function(){
      liveSearch.state = liveSearch.$form.serializeArray();
    },
    updateResults: function(){
      if(typeof liveSearch.cache() === 'undefined'){
        liveSearch.showLoadingIndicator();
        return $.ajax({
          url: liveSearch.action,
          data: liveSearch.state,
        }).done(function(response){
          liveSearch.cache(response);
          liveSearch.hideLoadingIndicator();
          liveSearch.displayResults();
        });
      } else {
        liveSearch.displayResults();
        var out = new $.Deferred()
        return out.resolve();
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
      var results = liveSearch.cache();

      liveSearch.$resultCount.text(results.result_count + ' found on GOV.UK');
      liveSearch.$results.html(results.results);
    },
    restoreCheckboxes: function(){
      liveSearch.$form.find('input[type=checkbox]').each(function(i, el){
        var $el = $(el)
        $el.prop('checked', liveSearch.isCheckboxSelected($el.attr('name'), $el.attr('value')));
      });
    },
    isCheckboxSelected: function(name, value){
      var i, _i;
      for(i=0,_i=liveSearch.state.length; i<_i; i++){
        if(liveSearch.state[i].name === name && liveSearch.state[i].value === value){
          return true;
        }
      }
      return false;
    }


  };
  GOVUK.liveSearch = liveSearch;
}());
