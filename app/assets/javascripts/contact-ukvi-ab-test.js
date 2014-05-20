//= require govuk/multivariate-test

$(function(){
  var disclaimer = '<p>Because of high call volumes the UK Visas and Immigration contact centre is currently not accepting calls.</p>';
  var replacePhoneNumberWithExplanation = function() {
    $('.contact').
      removeClass('contact').
      addClass('application-notice info-notice').
      html(disclaimer);
  };

  GOVUK.hideContactCentrePhoneNumbers = function() {
    if (window.location.href.indexOf("/contact-ukvi/visas-and-settlement") > -1) {
      replacePhoneNumberWithExplanation();
    } else if (window.location.href.indexOf("/contact-ukvi/british-citizenship-and-nationality") > -1) {
      $('.contact').
        html('<p><strong>Citizenship and nationality enquiries</strong><br><a href="mailto:ukbanationalityenquiries@ukba.gsi.gov.uk">ukbanationalityenquiries@ukba.gsi.gov.uk</a></p>').
        after('<div class="application-notice info-notice">' + disclaimer + '</div>');
    } else if (window.location.href.indexOf("/contact-ukvi/european-nationals") > -1) {
      $('.application-notice.info-notice:eq(1)').removeClass('application-notice info-notice');
      replacePhoneNumberWithExplanation();
    };
  };

  if(window.location.href.indexOf("/contact-ukvi/visas-and-settlement") > -1 ||
     window.location.href.indexOf("/contact-ukvi/british-citizenship-and-nationality") > -1 ||
     window.location.href.indexOf("/contact-ukvi/european-nationals") > -1 ) {
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
