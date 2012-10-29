jQuery(document).ready(function() {
  $('#video-transcript-toggle').removeClass('visuallyhidden');
  $('#video-transcript-toggle').on('click', function() {
    $('.video-transcript').toggle();
      return false;
  });
});
