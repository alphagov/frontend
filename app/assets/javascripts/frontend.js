// Frontend manifest
// Note: The ordering of these JavaScript includes matters.
//= require transactions
//= require media-player-loader
//= require support
//= require shared_mustache
//= require templates
//= require_tree ./modules
//= require components/task-list

$(document).ready(function() {
  $('.error-summary').focus();
});
