(function() {
  "use strict";

  window.GOVUK = window.GOVUK || {};

  var liveSearch = {
    action: false,
    state: false,
    previousState: false,
    resultCache: {},

    $form: false,
    $resultCount: false,
    $ariaLiveResultCount: false,

    init: function(){
      if(GOVUK.support.history()){
        liveSearch.$form = $('.js-live-search-form');
        liveSearch.$ariaLiveResultCount = $('.js-aria-live-count');
        if(liveSearch.$form){
          liveSearch.$resultsBlock = $('.js-live-search-results-block');

          liveSearch.action = liveSearch.$form.attr('action') + '.json';

          liveSearch.saveState();

          liveSearch.$form.on('change', 'input[type=checkbox]', liveSearch.checkboxChange);
          $(window).on('popstate', liveSearch.popState);
        }
      } else {
        $('.js-live-search-fallback').show();
      }
    },
    popState: function(event){
      if(event.originalEvent.state){
        liveSearch.saveState(state);
        liveSearch.updateResults();
        liveSearch.restoreCheckboxes();
        liveSearch.pageTrack();
      }
    },
    pageTrack: function(){
      if(window._gaq && _gaq.push){
        _gaq.push(["_setCustomVar",5,"ResultCount",liveSearch.cache().result_count,3]);
        _gaq.push(['_trackPageview']);
      }
    },
    checkboxChange: function(e){
      var pageUpdated;
      if(liveSearch.checkFilterLimit(e) && liveSearch.isNewState()){
        liveSearch.saveState();
        pageUpdated = liveSearch.updateResults();
        pageUpdated.done(function(){
          history.pushState(liveSearch.state, '', window.location.pathname + "?" + $.param(liveSearch.state));
          liveSearch.pageTrack();
        });
      }
    },
    checkFilterLimit: function(e){
      var newState = liveSearch.$form.serializeArray(),
          filterCount = 0,
          i, _i;

      for(i=0,_i=newState.length; i<_i; i++){
        if(newState[i].name.lastIndexOf('filter_', 0) === 0){
          filterCount = filterCount + 1;
        }
      }
      if(filterCount >= 15){
        $(e.target).prop('checked', false);
        alert('You can only apply 15 filters at once. Please remove a filter before adding one');
        return false;
      }
      return true;
    },
    cache: function(data){
      if(typeof data === 'undefined'){
        return liveSearch.resultCache[$.param(liveSearch.state)];
      } else {
        liveSearch.resultCache[$.param(liveSearch.state)] = data;
      }
    },
    isNewState: function(){
      return $.param(liveSearch.state) !== liveSearch.$form.serialize();
    },
    saveState: function(state){
      if(typeof state === 'undefined'){
        state = liveSearch.$form.serializeArray();
      }
      liveSearch.previousState = liveSearch.state;
      liveSearch.state = state;
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
        }).error(function(){
          liveSearch.showErrorIndicator();
        });
      } else {
        liveSearch.displayResults();
        var out = new $.Deferred()
        return out.resolve();
      }
    },
    showLoadingIndicator: function(){
      liveSearch.$resultCount = $('#js-live-search-result-count');
      liveSearch._resultCountText = liveSearch.$resultCount.text();
      liveSearch.$resultCount.text('Loading...');
    },
    hideLoadingIndicator: function(){
      liveSearch.$resultCount.text(liveSearch._resultCountText);
    },
    showErrorIndicator: function(){
      liveSearch.$resultCount.text('Error. Please try modifying your search and trying again');
    },
    displayResults: function(){
      var results = liveSearch.cache();

      if(liveSearch.searchTermValue(liveSearch.previousState) === liveSearch.searchTermValue(liveSearch.state)){
        liveSearch.$resultsBlock.find('.js-live-search-results-list').mustache('search/_results_list', results);
      } else {
        liveSearch.$resultsBlock.mustache('search/_results_block', results);
        liveSearch.$resultsBlock.find('.js-openable-filter').each(function(){
          new GOVUK.CheckboxFilter({el:$(this)});
        })
      }
      liveSearch.updateAriaLiveCount();
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
    },
    searchTermValue: function(state){
      if(!state){
        return false
      }
      var i, _i;
      for(i=0,_i=state.length; i<_i; i++){
        if(state[i].name === 'q'){
          return state[i].value;
        }
      }
      return false;
    },
    updateAriaLiveCount: function(){
      liveSearch.$ariaLiveResultCount.text(liveSearch.$resultsBlock.find('.result-count').text());
    }
  };
  GOVUK.liveSearch = liveSearch;
}());
