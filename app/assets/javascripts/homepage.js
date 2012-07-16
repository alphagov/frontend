// Homepage manifest
//= require_self
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
  initSuggestions();
});
