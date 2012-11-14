jQuery(document).ready(function() {
  $('.video-transcript-toggle').removeClass('visuallyhidden');
  $('.video-transcript-toggle').on('click', function() {
    $($(this).attr("href")).toggle();
      return false;
  });
});
