$(function() {
  var $tabs = $('#search-results-tabs'),
      $searchForm = $('.js-search-hash');

  if($tabs.length > 0){
    $tabs.tabs({ 'defaultTab' : getSelectedSearchTabIndex(), scrollOnload: true });
  }

  function getSelectedSearchTabIndex(){
    var tabIds = $('.search-navigation a').map(function(i, el){
      return $(el).attr('href').split('#').pop();
    });
    $selectedTab = $('input[name=tab]');
    selectedTab = $.inArray($selectedTab.val(), tabIds);

    return selectedTab > -1 ? selectedTab : 0;
  }

  if($searchForm.length){
    $tabs.on('tabChanged', updateSearchForms);
  }

  // Update the forms so that the selected tab is remembered for the next search.
  // This function applies to any form with the "tab" hidden input in it:
  //   * form at the top
  //   * government filtering form
  function updateSearchForms(e, hash){
    if(typeof hash !== 'undefined'){
      var $selectedTab = $('input[name=tab]');

      if($selectedTab.length === 0){
        $selectedTab = $('<input type="hidden" name="tab">');
        $searchForm.prepend($selectedTab);
      }

      $selectedTab.val(hash);
    }
  }
});
