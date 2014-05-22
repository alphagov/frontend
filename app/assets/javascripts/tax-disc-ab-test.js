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
        control1: { callback: function () { } },
        control2: { callback: function () { } },
        control3: { callback: function () { } },
        control4: { callback: function () { } },
        control5: { callback: function () { } },
        control6: { callback: function () { } },
        control7: { callback: function () { } },
        control8: { callback: function () { } },
        control9: { callback: function () { } },
        tax_disc_beta1: { callback: GOVUK.taxDiscBetaPrimary }
      }
    });
  }
});
