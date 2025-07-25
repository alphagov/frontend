APP_STYLESHEETS = {
  "application.scss" => "application.css",
  "static-error-pages.scss" => "static-error-pages.css",
  "components/_calendar.scss" => "components/_calendar.css",
  "components/_download-link.scss" => "components/_download-link.css",
  "views/_calendars.scss" => "views/_calendars.css",
  "views/_cookie-settings.scss" => "views/_cookie-settings.css",
  "views/_csv_preview.scss" => "views/_csv_preview.css",
  "views/_homepage_header.scss" => "views/_homepage_header.css",
  "views/_homepage_more_on_govuk.scss" => "views/_homepage_more_on_govuk.css",
  "views/_homepage.scss" => "views/_homepage.css",
  "views/_local-transaction.scss" => "views/_local-transaction.css",
  "views/_location_form.scss" => "views/_location_form.css",
  "views/_place-list.scss" => "views/_place-list.css",
  "views/_popular_links.scss" => "views/_popular_links.css",
  "views/_published-dates-button-group.scss" => "views/_published-dates-button-group.css",
  "views/_publisher_metadata.scss" => "views/_publisher_metadata.css",
  "views/_roadmap.scss" => "views/_roadmap.css",
  "views/_service-manual-guide.scss" => "views/_service-manual-guide.css",
  "views/_service-manual-service-standard.scss" => "views/_service-manual-service-standard.css",
  "views/_service-manual-topic.scss" => "views/_service-manual-topic.css",
  "views/_service-toolkit.scss" => "views/_service-toolkit.css",
  "views/_sidebar-navigation.scss" => "views/_sidebar-navigation.css",
  "views/_specialist-document.scss" => "views/_specialist-document.css",
  "views/_travel-advice.scss" => "views/_travel-advice.css",
  "views/_landing_page.scss" => "views/_landing_page.css",
  "views/_landing_page/block-error.scss" => "views/_landing_page/block-error.css",
  "views/_landing_page/box.scss" => "views/_landing_page/box.css",
  "views/_landing_page/card.scss" => "views/_landing_page/card.css",
  "views/_landing_page/columns_layout.scss" => "views/_landing_page/columns_layout.css",
  "views/_landing_page/hero.scss" => "views/_landing_page/hero.css",
  "views/_landing_page/image.scss" => "views/_landing_page/image.css",
  "views/_landing_page/logo.scss" => "views/_landing_page/logo.css",
  "views/_landing_page/featured.scss" => "views/_landing_page/featured.css",
  "views/_landing_page/main-navigation.scss" => "views/_landing_page/main-navigation.css",
  "views/_landing_page/map.scss" => "views/_landing_page/map.css",
  "views/_landing_page/quote.scss" => "views/_landing_page/quote.css",
  "views/_landing_page/side-navigation.scss" => "views/_landing_page/side-navigation.css",
  "views/_landing_page/themes/prime-ministers-office-10-downing-street.scss" => "views/_landing_page/themes/prime-ministers-office-10-downing-street.css",
}.freeze

all_stylesheets = APP_STYLESHEETS.merge(GovukPublishingComponents::Config.all_stylesheets)
Rails.application.config.dartsass.builds = all_stylesheets

Rails.application.config.dartsass.build_options << " --quiet-deps"
