// Frontend manifest
// Note: The ordering of these JavaScript includes matters.
//= require transactions
//= require support
//= require templates
//= require_tree ./modules
//= require govuk_publishing_components/all_components

$(document).ready(function() {
  $('.error-summary').focus();
});
