//= require govuk/multivariate-test

/*jslint browser: true,
 *  indent: 2,
 *  white: true
 */
/*global $, GOVUK */
$(function () {

  GOVUK.taxDiscBetaAvailable = function () {
    $('.primary-apply').html($('#beta-available').html());
  };

  GOVUK.taxDiscBetaOffline = function () {
    $('.primary-apply').html($('#beta-offline').html());
  };

  if(window.location.href.indexOf("/tax-disc") > -1) {
    new GOVUK.MultivariateTest({
      name: 'tax-disc-beta-availability',
      customVarIndex: 20,
      cohorts: {
        tax_disc_beta_offline: { weight: 0.2, callback: GOVUK.taxDiscBetaOffline }, //~20%
        tax_disc_beta_available: { weight: 0.8, callback: GOVUK.taxDiscBetaAvailable } //~80%
      }
    });
  }
});
