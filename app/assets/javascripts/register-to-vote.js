//= require govuk/multivariate-test

$(function(){
  if(window.location.href.indexOf("/register-to-vote") > -1) {
    // Get the current cohort or assign one if it has not been already
    GOVUK.MultivariateTest.prototype.getCohort = function() {
      var cohort = GOVUK.cookie(this.cookieName());
      if (!cohort || !this.cohorts[cohort]) {
        cohort = this.chooseRandomCohort();
        // x minutes in days: x / (60 minutes * 24 hours)
        var minutesForCohort = 5,
          minutesInDay = 1440; // 60 * 24
        GOVUK.cookie(this.cookieName(), cohort, {days: minutesForCohort / minutesInDay});
      }
      return cohort;
    };

    GOVUK.MultivariateTest.prototype.setCustomVar = function(cohort) {
      if (this.customDimensionIndex) {
        GOVUK.analytics.setDimension(
          this.customDimensionIndex,
          this.cookieName() + "__" + cohort
        );
      }
    };

    var bContent = $('#get-started-b-content').html();

    new GOVUK.MultivariateTest({
      el: '.get-started',
      name: 'registerToVote_rateLimit_201606',
      customDimensionIndex: 14,
      cohorts: {
        a: { callback: function() {}, variantId: 0, weight: 75 },
        b: { callback: function() {
          $('.get-started').replaceWith(bContent);
        }, variantId: 1, weight: 25 },
      }
    });
  }
});
