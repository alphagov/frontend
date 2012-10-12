$(document).ready(function () {

  $('#authority-selector-form').removeClass('visuallyhidden');
  $('.local-service-unavailable-notice').addClass('visuallyhidden');
  $('#authority-selector-form').submit( function(e) {
    e.preventDefault();
    authority_slug = $(this).find('select[name=authority]').val();
    window.location = window.location + '/' + authority_slug;
  });

});
