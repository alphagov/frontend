//= require govuk/multivariate-test

$(function(){
  GOVUK.hideContactCentrePhoneNumber = function() {
    $('.contact').removeClass('contact').addClass('application-notice info-notice').html('<p>Because of high call volumes the UK Visas and Immigration contact centre is currently not accepting calls.</p>');
  };

  if(window.location.href.indexOf("/contact-ukvi/visas-and-settlement") > -1) {
    new GOVUK.MultivariateTest({
      name: 'contact_ukvi_visas_and_settlement_contact_centre',
      customVarIndex: 13,
      cohorts: {
        control: { callback: function() {} },
        /* because GOVUK.MultivariateTest isn't able to weight the variants,
        in order to get an 80/20 traffic distribution, the 80% variant needs to be
        present 4 times */
        hide_number1: { callback: GOVUK.hideContactCentrePhoneNumber },
        hide_number2: { callback: GOVUK.hideContactCentrePhoneNumber },
        hide_number3: { callback: GOVUK.hideContactCentrePhoneNumber },
        hide_number4: { callback: GOVUK.hideContactCentrePhoneNumber },
      }
    });
  }
});
