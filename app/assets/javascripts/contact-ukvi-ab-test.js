//= require govuk/multivariate-test
/*jslint browser: true,
 indent: 2,
 white: true
*/
/*global $, GOVUK */
$(function(){
  "use strict";

  function pathInLocation(path) {
    return (window.location.href.indexOf(path) > -1);
  }

  function replaceContactDetails() {
    var textToReplaceWith;
    if (pathInLocation("/contact-ukvi/british-citizenship-and-nationality")) {
      textToReplaceWith = '<p><strong>Citizenship and nationality enquiries</strong><br><a href="mailto:ukbanationalityenquiries@ukba.gsi.gov.uk">ukbanationalityenquiries@ukba.gsi.gov.uk</a></p>';
    }
    else if (pathInLocation('/contact-ukvi/european-nationals')) {
      textToReplaceWith = '<p>You may be able to find the information you need on GOV.UK about <a href="/browse/visas-immigration/eu-eea-commonwealth">EU, EEA and Commonwealth citizens</a>.';
    }
    else if (pathInLocation('/contact-ukvi/visas-and-settlement')) {
      textToReplaceWith = '<p>You may be able to find the information you need on GOV.UK about <a href="/check-uk-visa">visas eligibility</a> and <a href="/browse/visas-immigration/settling-in-the-uk">settlement</a>.</p>';
    }
    if (textToReplaceWith) {
      $('.contact').removeClass('contact').html(textToReplaceWith);
    }
  }

  GOVUK.hideContactCentrePhoneNumbers = function() {
    replaceContactDetails();
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
