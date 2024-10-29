module ContentsListHelper
  def contents_list(current_path, links)
    links.map do |link|
      content = {
        href: link["href"],
        text: link["text"],
      }

      content[:active] = true if current_path == link["href"]
      content[:links] = contents_list(current_path, link["links"]) if link["links"].present?

      content
    end
  end
end
