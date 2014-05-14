$(function() {
  var $unified = $('#unified-results');

  if ($unified.length > 0) {
    $('.js-openable-filter').each(function(){
      new GOVUK.CheckboxFilter({el:$(this)});
    })
    GOVUK.liveSearch.init();
  };

  (function trackSearchClicks(){
    if($unified.length === 0 || !GOVUK.cookie){
      return false;
    }
    $unified.on('click', 'a', function(e){
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

      gaParams[3] = 'position='+position+sublink;
      GOVUK.cookie('ga_nextpage_params', gaParams.join(','));
    });
  }());

});
