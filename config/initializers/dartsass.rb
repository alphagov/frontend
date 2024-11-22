APP_STYLESHEETS = {
  "application.scss" => "application.css",
  "components/_calendar.scss" => "components/_calendar.css",
  "components/_figure.scss" => "components/_figure.css",
  "components/_subscribe.scss" => "components/_subscribe.css",
  "components/_published-dates.scss" => "components/_published-dates.css",
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
  "views/_travel-advice.scss" => "views/_travel-advice.css",
  "views/_landing_page.scss" => "views/_landing_page.css",
  "views/_landing_page/box.scss" => "views/_landing_page/box.css",
  "views/_landing_page/card.scss" => "views/_landing_page/card.css",
  "views/_landing_page/columns_layout.scss" => "views/_landing_page/columns_layout.css",
  "views/_landing_page/hero.scss" => "views/_landing_page/hero.css",
  "views/_landing_page/featured.scss" => "views/_landing_page/featured.css",
  "views/_landing_page/grid.scss" => "views/_landing_page/grid.css",
  "views/_landing_page/main-navigation.scss" => "views/_landing_page/main-navigation.css",
  "views/_landing_page/quote.scss" => "views/_landing_page/quote.css",
}.freeze

all_stylesheets = APP_STYLESHEETS.merge(GovukPublishingComponents::Config.all_stylesheets)
Rails.application.config.dartsass.builds = all_stylesheets

Rails.application.config.dartsass.build_options << " --quiet-deps"
