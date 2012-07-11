// Homepage manifest
//= require jquery.scrollTo-1.4.2-min.js
//= require jquery.serialScroll-1.2.2-min.js
//= require jquery.localscroll-1.2.7-min.js
//= require_self

function initScroll() {
  // Set wrapper width to total width of all children
  var w=0;
  $('.homepage-carousel').find('li').each(function(){
    w += $(this).outerWidth(true);
  }).end().width(w);

  $('.homepage-carousel-wrapper').serialScroll({
    axis: 'x',
    duration: 800,
    easing: 'easeInOutQuad',
    step: 1,
    cycle: true,
    items: 'li',
    interval: 8000,
    force: true,
    exclude: 3
    // prev: '.homepage-carousel-controls .prev a',
    // next: '.homepage-carousel-controls .next a',
  });

  // event handlers for controls
  $('.homepage-carousel-controls')
  .on('click', '.prev a', function(e) {
    e.preventDefault();
    $('.homepage-carousel-wrapper').trigger('prev');
  }).on('click', '.next a', function(e) {
    e.preventDefault();
    $('.homepage-carousel-wrapper').trigger('next');
  }).on('click', '.pause a', function(e) {
    e.preventDefault();
    $('.homepage-carousel-wrapper').trigger('stop');

    $(this).text('Play').parent('li').removeClass('pause').addClass('play');
  }).on('click', '.play a', function(e) {
    e.preventDefault();
    $('.homepage-carousel-wrapper').trigger('start');

    $(this).text('Pause').parent('li').removeClass('play').addClass('pause');
  });

  // if carousel item gets focus from a keydown event, scroll it into view and stop auto animating
  $('.homepage-carousel').on('keydown', 'a', function(e){
    if (e.which != 13) {
      $('.homepage-carousel-wrapper').trigger('stop');
      $('.homepage-carousel-wrapper').scrollTo($(this).parent());
    }
  });
  
  // animated scroll to browse sections
  $('#homepage').localScroll({
    hash: true,
    duration: 1200,
    easing: 'easeOutQuad',
    offset: {top: '-60px'}
  });
}

function initSuggestions() {
  var $li = $('#homepage-search-suggestion').find('li');
  var i = Math.floor(Math.random() * $li.length);
  $li.hide().eq(i).show();
  setInterval(function() { cycleSuggestion(); }, 12000);
}

function cycleSuggestion() {
  var $li = $('#homepage-search-suggestion').find('li:visible').fadeOut(800, function() {
    $(this).next().fadeIn(800);
    if ($(this).next().length < 1) {
      $(this).siblings().first().fadeIn(800);
    }
  });
}



$(document).ready(function() {
  initScroll();
  initSuggestions();
});
