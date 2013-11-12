$(document).ready(function () {
  var $container = $('section.more');

  if ($container.find('.js-tabs').length) {
    $container.tabs();
  }

  $('form#completed-transaction-form').append('<input type="hidden" name="service_feedback[javascript_enabled]" value="true"/>');
});
