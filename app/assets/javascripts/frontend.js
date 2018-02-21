// Frontend manifest
// Note: The ordering of these JavaScript includes matters.
//= require transactions
//= require media-player-loader
//= require support
//= require templates
//= require_tree ./modules
//= require current-location
//= require govuk_publishing_components/components/step-by-step-nav
//= require govuk_publishing_components/components/feedback

$(document).ready(function() {
  $('.error-summary').focus();
});
