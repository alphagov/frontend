(function() {
  "use strict";
  if(window.location.href.indexOf("/help") > -1){
    var test = new GOVUK.MultivariateTest({
      name: 'help_aa_test',
      contentExperimentId: "Urx3qleIQJ6K2oJXdcsZ1A",
      cohorts: {
        variant_0: {variantId: 0},
        variant_1: {variantId: 1}
      }
    });
  };
}());
