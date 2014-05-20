//= require govuk/multivariate-test
/*jslint browser: true,
 indent: 2,
 white: true
*/
/*global $, GOVUK */
$(function(){
  "use strict";
  var disclaimer = '<p>Because of high call volumes the UK Visas and Immigration contact centre is currently not accepting calls.</p>',
  replacePhoneNumberWithExplanation = function() {
    $('.contact').
      removeClass('contact').
      addClass('application-notice info-notice').
      html(disclaimer);
  };

  function pathInLocation(path) {
    return (window.location.href.indexOf(path) > -1);
  }

  GOVUK.hideContactCentrePhoneNumbers = function() {
    if (pathInLocation("/contact-ukvi/visas-and-settlement")) {
      replacePhoneNumberWithExplanation();
    } else if (pathInLocation("/contact-ukvi/british-citizenship-and-nationality")) {
      $('.contact').
        html('<p><strong>Citizenship and nationality enquiries</strong><br><a href="mailto:ukbanationalityenquiries@ukba.gsi.gov.uk">ukbanationalityenquiries@ukba.gsi.gov.uk</a></p>').
        after('<div class="application-notice info-notice">' + disclaimer + '</div>');
    } else if (pathInLocation("/contact-ukvi/european-nationals")) {
      $('.application-notice.info-notice:eq(1)').removeClass('application-notice info-notice');
      replacePhoneNumberWithExplanation();
    }
  };

  if(pathInLocation("/contact-ukvi/visas-and-settlement") ||
     pathInLocation("/contact-ukvi/british-citizenship-and-nationality") ||
     pathInLocation("/contact-ukvi/european-nationals") ) {
    new GOVUK.MultivariateTest({
      name: 'contact_ukvi_visas_and_settlement_contact_centre_50_50',
      customVarIndex: 13,
      cohorts: {
        control: { callback: function() {} },
        hide_number: { callback: GOVUK.hideContactCentrePhoneNumbers }
      }
    });
  }
});
