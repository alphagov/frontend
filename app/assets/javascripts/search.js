$(function() {
  var $tabs = $('#search-results-tabs'),
      $searchForm = $('.js-search-hash');

  if($tabs.length > 0){
    $tabs.tabs({ 'defaultTab' : getDefaultSearchTab() });
  }

  function getDefaultSearchTab(){
    var tabIds = $('.nav-tabs a').map(function(i, el){
          return $(el).attr('href').split('#').pop();
        }),
        $defaultTab = $('input[name=tab]'),
        selectedTab = $.inArray($defaultTab.val(), tabIds);

    return selectedTab > -1 ? selectedTab : 0;
  }

  if($searchForm.length){
    $tabs.on('tabChanged', updateSearchForm);
  }

  function updateSearchForm(e, hash){
    if(typeof hash !== 'undefined'){
      var $defaultTab = $('input[name=tab]');

      if($defaultTab.length === 0){
        $defaultTab = $('<input type="hidden" name="tab">');
        $searchForm.prepend($defaultTab);
      }

      $defaultTab.val(hash);
    }
  }
});
