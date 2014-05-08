//= require govuk/multivariate-test

$(function () {

  GOVUK.taxDiscBetaPrimary = function () {
    $('.primary-apply').html($('#beta-primary').html());
    $('.secondary-apply').html($('#dvla-secondary').html());
  };

  if(window.location.href.indexOf("/tax-disc") > -1) {
    new GOVUK.MultivariateTest({
      name: 'tax-disc',
      customVarIndex: 14,
      cohorts: {
        control: { callback: function () { } },
        tax_disc_beta1: { callback: GOVUK.taxDiscBetaPrimary }
      }
    });
  }
});
