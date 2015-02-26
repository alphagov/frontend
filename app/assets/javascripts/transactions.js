(function () {

  "use strict"

  window.GOVUK = window.GOVUK || {};

  window.GOVUK.Transactions = {
    trackStartPageTabs : function (e) {
      var pagePath = e.target.href;
      GOVUK.analytics.trackEvent('startpages', 'tab', {label: pagePath, nonInteraction: true});
    }
  };

})();

$(document).ready(function () {

  var $container = $('section.more');

  if ($container.find('.js-tabs').length) {
    $container.tabs();
  }

  $('form#completed-transaction-form').
    append('<input type="hidden" name="service_feedback[javascript_enabled]" value="true"/>').
    append($('<input type="hidden" name="referrer">').val(document.referrer || "unknown"));

  $('#completed-transaction-form button.button').click(function() {
    $(this).attr('disabled', 'disabled');
    $(this).parents('form').submit();
  });

  $('.transaction .nav-tabs a').click(window.GOVUK.Transactions.trackStartPageTabs);

});
