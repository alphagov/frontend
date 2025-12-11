module PartsNavigationHelper
  def previous_and_next_navigation(previous_part, next_part, draft_token: nil)
    nav = {}

    if previous_part
      nav[:previous_page] = {
        href: url_with_draft_token(previous_part["full_path"], draft_token),
        title: I18n.t("multi_page.previous_page"),
        label: previous_part["title"],
      }
    end

    if next_part
      nav[:next_page] = {
        href: url_with_draft_token(next_part["full_path"], draft_token),
        title: I18n.t("multi_page.next_page"),
        label: next_part["title"],
      }
    end

    nav
  end

  def part_link_elements(parts, current_part, draft_token: nil)
    parts.map do |part|
      if part["slug"] != current_part["slug"]
        { href: url_with_draft_token(part["full_path"], draft_token), text: part["title"] }
      else
        { href: url_with_draft_token(part["full_path"], draft_token), text: part["title"], active: true }
      end
    end
  end

private

  def url_with_draft_token(url, draft_token)
    draft_token ? "#{url}?token=#{draft_token}" : url
  end
end
