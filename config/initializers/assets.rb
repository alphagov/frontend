Rails.application.config.assets.precompile += %w(manifest.js)

Rails.application.config.assets.precompile += %w(
  all.js
  frontend.js
  support.js
  transations.js
  application-ie6.css
  application-ie7.css
  application-ie8.css
  application.css
  print.css
)

Rails.application.config.assets.version = "1.0"
