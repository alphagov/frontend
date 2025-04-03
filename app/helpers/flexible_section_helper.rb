module FlexibleSectionHelper
  def render_flexible_section(flexible_section)
    render("flexible_page/flexible_sections/#{flexible_section.type}", flexible_section:)
  end
end
