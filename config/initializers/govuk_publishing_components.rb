if defined?(GovukPublishingComponents)
  GovukPublishingComponents.configure do |c|
    c.component_guide_title = "Frontend Component Guide"
    c.exclude_css_from_static = false
  end
end
