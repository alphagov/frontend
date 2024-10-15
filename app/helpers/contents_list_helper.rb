module ContentsListHelper
  def contents_list(current_path, links)
    links.map do |link|
      content = {
        href: link["href"],
        text: link["text"],
      }

      content[:active] = true if current_path == link["href"]
      content[:items] = contents_list(current_path, link["items"]) if link["items"].present?

      content
    end
  end
end
