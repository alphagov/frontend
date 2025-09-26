if defined?(GovukPublishingComponents)
  GovukPublishingComponents.configure do |c|
    c.component_guide_title = "Frontend Component Guide"
    c.application_stylesheet = "application"
    c.custom_css_exclude_list = %w[
      button
      cookie-banner
      feedback
      heading
      input
      label
      layout-footer
      layout-for-public
      layout-super-navigation-header
      search
      search-with-autocomplete
      skip-link
    ]
  end
end
