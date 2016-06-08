//= require govuk/multivariate-test

$(function(){
  if(window.location.href.indexOf("/register-to-vote") > -1) {
    // Get the current cohort or assign one if it has not been already
    GOVUK.MultivariateTest.prototype.getCohort = function() {
      var cohort = GOVUK.cookie(this.cookieName());
      if (!cohort || !this.cohorts[cohort]) {
        cohort = this.chooseRandomCohort();
        // x minutes in days: x / (60 minutes * 24 hours)
        var minutesForCohort = 1,
          minutesInDay = 1440; // 60 * 24
        GOVUK.cookie(this.cookieName(), cohort, {days: minutesForCohort / minutesInDay});
      }
      return cohort;
    };

    var bContent = $('#get-started-b-content').html();

    new GOVUK.MultivariateTest({
      el: '.get-started',
      name: 'registerToVote_rateLimit_201606',
      customDimensionIndex: 14,
      cohorts: {
        a: { callback: function() {}, variantId: 0, weight: 50 },
        b: { html: bContent, variantId: 1, weight: 50 },
      }
    });
  }
});
