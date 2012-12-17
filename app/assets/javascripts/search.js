$(function() {
  $('#search-results-tabs').tabs({ 'defaultTab' : 0 });

  var $searchForm = $('.js-search-hash');
  if($searchForm.length){
    updateSearchFormHash();
    $('#search-results-tabs').on('tabChanged', updateSearchFormHash);
  }

  function updateSearchFormHash(e, hash){
    var action = $searchForm.attr('action');

    if(typeof hash === 'undefined'){
      hash = window.location.hash;
    }

    if(hash.length){
      if(action.indexOf('#') > -1){
        action = action.split('#')[0];
      }
      if(hash.indexOf('#') > -1){
        hash = hash.split('#')[1];
      }

      $searchForm.attr('action', action + '#' + hash);
    }
  }
});
