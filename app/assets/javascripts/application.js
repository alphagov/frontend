// Frontend manifest
// Note: The ordering of these JavaScript includes matters.

//= require govuk_publishing_components/vendor/polyfills/closest
//= require govuk_publishing_components/vendor/polyfills/common
//= require govuk_publishing_components/vendor/polyfills/indexOf

// The `gem_layout` template from Static provides cookie-functions,
// header-navigation, and track-click from the the components `lib` folder - so
// they're not required here.

//= require govuk_publishing_components/lib/current-location
//= require govuk_publishing_components/lib/initial-focus
//= require govuk_publishing_components/lib/primary-links
//= require govuk_publishing_components/lib/select
//= require govuk_publishing_components/lib/toggle-input-class-on-focus
//= require govuk_publishing_components/lib/toggle
//= require govuk_publishing_components/lib/track-click
//= require govuk_publishing_components/lib/trigger-event

//= require govuk_publishing_components/lib/govspeak/barchart-enhancement
//= require govuk_publishing_components/lib/govspeak/magna-charta
//= require govuk_publishing_components/lib/govspeak/youtube-link-enhancement

//= require govuk_publishing_components/components/button
//= require govuk_publishing_components/components/character-count
//= require govuk_publishing_components/components/details
//= require govuk_publishing_components/components/feedback
//= require govuk_publishing_components/components/govspeak
//= require govuk_publishing_components/components/radio
//= require govuk_publishing_components/components/step-by-step-nav
//= require govuk_publishing_components/components/tabs

//= require transactions
//= require support
//= require_tree ./modules

//= require ./views/save-location
