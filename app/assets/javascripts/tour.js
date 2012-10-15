jQuery(document).ready(function() { 
  $('.tour-video a').on('click', function() {
    $('.video-transcript').toggle();
      return false;
  });
});