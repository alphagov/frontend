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
      name: 'tax-disc-beta',
      customVarIndex: 20,
      cohorts: {
        tax_disc_beta_control: { weight: 0, callback: function () { } }, //~0%
        tax_disc_beta: { weight: 1, callback: GOVUK.taxDiscBetaPrimary } //~100%
      }
    });
  }
});
