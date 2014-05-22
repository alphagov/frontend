//= require govuk/multivariate-test

/*jslint browser: true,
 *  indent: 2,
 *  white: true
 */
/*global $, GOVUK */
$(function () {

  GOVUK.taxDiscBetaPrimary = function () {
    $('.primary-apply').html($('#beta-primary').html());
    $('.secondary-apply').html($('#dvla-secondary').html());
  };

  if(window.location.href.indexOf("/tax-disc") > -1) {
    new GOVUK.MultivariateTest({
      name: 'tax-disc',
      customVarIndex: 20,
      cohorts: {
        tax_disc_beta_control1: { callback: function () { } },
        tax_disc_beta_control2: { callback: function () { } },
        tax_disc_beta_control3: { callback: function () { } },
        tax_disc_beta_control4: { callback: function () { } },
        tax_disc_beta1: { callback: GOVUK.taxDiscBetaPrimary }
      }
    });
  }
});
