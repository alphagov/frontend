module FlexibleSectionHelper
  def render_flexible_section(flexible_section, options: {})
    render("flexible_page/flexible_sections/#{flexible_section.type}", flexible_section:, options:)
  end
end
