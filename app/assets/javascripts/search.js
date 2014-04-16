$(function() {
  var $tabs = $('#search-results-tabs'),
      $unified = $('#unified-results'),
      $searchForm = $('.js-search-hash');

  if($tabs.length > 0){
    $tabs.tabs({ 'defaultTab' : getSelectedSearchTabIndex(), scrollOnload: true });
  }

  if ($unified.length > 0) {

    $('.js-openable-filter').each(function(){
      new GOVUK.CheckboxFilter({el:$(this)});
    })

    if (history.pushState) {
      $('.filter-form .actions').hide();
      filterByOrg();
      removeOrgFilters();
    };
  };

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

  function filterByOrg(){
    $('#organisations-filter input[type=checkbox]').change(function() {
      var new_url = ""
      if ($(this).attr('checked')) {
        new_url = window.location.href + "&filter_organisations%5B%5D=" + $(this).val();
        getOrgFilterResults(new_url);
      } else{
        org = ("&filter_organisations%5B%5D=" + $(this).val());
        regex = new RegExp(org, "g");
        new_url = window.location.href.replace(regex, "");
        getOrgFilterResults(new_url);
      };
    });
  }

  function getOrgFilterResults(url) {
    history.pushState(null, null, url);
    url = url.replace('search', 'search.json');
    $.ajax({
      url: url,
    }).done(function( data ) {
      $('.result-count').text(data['result_count'] + ' found on GOV.UK');
      $('.results-list').html(data['results']);
    });
  }

  function removeOrgFilters() {
    $('.clear-selected').click(function() {
      var pattern = "&filter_organisations%5B%5D=[^&]*"
      var regex = new RegExp(pattern, "g");
      getOrgFilterResults(window.location.href.replace(regex, ""));
    })
  }

  (function trackSearchClicks(){
    if(($tabs.length === 0 && $unified.length === 0) || !GOVUK.cookie){
      return false;
    }
    $('#services-information-results-enhanced a, #departments-policy-results-enhanced a, #top-results a, #unified-results a').click(function(e){
      var $link = $(e.target),
          sublink = '',
          gaParams = ['_setCustomVar', 21, 'searchPosition', '', 3],
          position, href;

      if($link.closest('ul').hasClass('sections')){
        href = $link.attr('href');
        if(href.indexOf('#') > -1){
          sublink = '&sublink='+href.split('#')[1];
        }
        $link = $link.closest('ul');
      }

      position = $link.closest('li').index() + 1; // +1 so it isn't zero offset

      if($unified.length === 0 && $link.closest('#top-results').length === 0){
        position = position + 3; // to allow for the top results
      }
      gaParams[3] = 'position='+position+sublink;
      GOVUK.cookie('ga_nextpage_params', gaParams.join(','));
    });
  }());

});
