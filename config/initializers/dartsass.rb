APP_STYLESHEETS = {
  "application.scss" => "application.css",
  "static-error-pages.scss" => "static-error-pages.css",
  "views/_calendars.scss" => "views/_calendars.css",
  "views/_cookie-settings.scss" => "views/_cookie-settings.css",
  "views/_csv_preview.scss" => "views/_csv_preview.css",
  "views/_flexible-content.scss" => "views/_flexible-content.css",
  "views/_event.scss" => "views/_event.css",
  "views/_guide.scss" => "views/_guide.css",
  "views/_homepage.scss" => "views/_homepage.css",
  "views/_html-publication.scss" => "views/_html-publication.css",
  "views/_local-transaction.scss" => "views/_local-transaction.css",
  "views/_location_form.scss" => "views/_location_form.css",
  "views/_manual.scss" => "views/_manual.css",
  "views/_place-list.scss" => "views/_place-list.css",
  "views/_published-dates-button-group.scss" => "views/_published-dates-button-group.css",
  "views/_publisher_metadata.scss" => "views/_publisher_metadata.css",
  "views/_roadmap.scss" => "views/_roadmap.css",
  "views/_service-manual-guide.scss" => "views/_service-manual-guide.css",
  "views/_service-manual-service-standard.scss" => "views/_service-manual-service-standard.css",
  "views/_service-manual-topic.scss" => "views/_service-manual-topic.css",
  "views/_service-toolkit.scss" => "views/_service-toolkit.css",
  "views/_sidebar-navigation.scss" => "views/_sidebar-navigation.css",
  "views/_sign-in.scss" => "views/_sign-in.css",
  "views/_travel-advice.scss" => "views/_travel-advice.css",
  "views/_worldwide-organisation.scss" => "views/_worldwide-organisation.css",
  "views/_landing_page.scss" => "views/_landing_page.css",
}.freeze

all_stylesheets = APP_STYLESHEETS.merge(GovukPublishingComponents::Config.component_guide_stylesheet)
Rails.application.config.dartsass.builds = all_stylesheets
Rails.application.config.dartsass.build_options << " --quiet-deps"
Rails.application.config.dartsass.build_options << " --silence-deprecation=import"
