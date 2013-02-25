$(document).ready(function () {
  var $container = $('section.more');

  if ($container.find('.js-tabs').length) {
    $container.tabs();
  }
});
