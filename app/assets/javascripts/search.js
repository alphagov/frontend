$(function() {
  var $tabs = $('#search-results-tabs'),
      $searchForm = $('.js-search-hash');

  if($tabs.length > 0){
    $tabs.tabs({ 'defaultTab' : getSelectedSearchTabIndex(), scrollOnload: true });
  }

  // Returns the index of the tab, or defaults to 0 (ie the first tab)
  //
  // To do this, it looks at which tab has the "active" class.
  // This might be the one that the user has selected, or one that the server
  // has defaulted to (eg the first tab might have no results, so we'd set the
  // second one as active)
  function getSelectedSearchTabIndex(){
    var tabIds = $('.search-navigation a').map(function(i, el){
      return $(el).attr('href').split('#').pop();
    });

    var activeTabId = $(".search-navigation li.active a").first()
                        .attr("href").replace("#", "");

    var tabIndex = $.inArray(activeTabId, tabIds);
    return tabIndex > -1 ? tabIndex : 0;
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
