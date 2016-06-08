//= require govuk/multivariate-test

$(function(){
  if(window.location.href.indexOf("/register-to-vote") > -1) {
    // Get the current cohort or assign one if it has not been already
    GOVUK.MultivariateTest.prototype.getCohort = function() {
      var cohort = GOVUK.cookie(this.cookieName());
      if (!cohort || !this.cohorts[cohort]) {
        cohort = this.chooseRandomCohort();
        // 10 minutes in days = 0.00694444444
        GOVUK.cookie(this.cookieName(), cohort, {days: 0.000694444444});
      }
      return cohort;
    };

    new GOVUK.MultivariateTest({
      el: '.get-started',
      name: 'registerToVote_rateLimit_201606',
      customDimensionIndex: 14,
      cohorts: {
        a: { callback: function() {}, variantId: 0 },
        b: { html: '<p>Sorry</p>', variantId: 1 },
      }
    });
  }
});
