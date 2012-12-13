$(document).ready(function () {
  var $container = $('section.more');

  if ($container.find('.js-tabs').length) {
    $container.tabs();
  }

  $('#get-started a.toolbar-disabled').click(function(e) {
    window.open($(this).attr('href'), 'govuk_transaction_window', 'toolbar=no,resizable=yes,scrollbars=yes')
    e.preventDefault();
  });
});
