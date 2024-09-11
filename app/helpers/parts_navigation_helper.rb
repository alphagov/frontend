module PartsNavigationHelper
  def previous_and_next_navigation(previous_part, next_part)
    nav = {}

    if previous_part
      nav[:previous_page] = {
        url: previous_part["full_path"],
        title: I18n.t("multi_page.previous_page"),
        label: previous_part["title"],
      }
    end

    if next_part
      nav[:next_page] = {
        url: next_part["full_path"],
        title: I18n.t("multi_page.next_page"),
        label: next_part["title"],
      }
    end

    nav
  end

  def part_link_elements(parts, current_part)
    parts.map do |part|
      if part["slug"] != current_part["slug"]
        { href: part["full_path"], text: part["title"] }
      else
        { href: part["full_path"], text: part["title"], active: true }
      end
    end
  end
end
