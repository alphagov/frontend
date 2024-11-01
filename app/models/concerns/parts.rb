module Parts
  extend ActiveSupport::Concern

  included do
    attr_reader :part_slug

    def parts
      raw_parts.each_with_index.map do |part, i|
        # Link to base_path for first part
        part["full_path"] = i.zero? ? base_path : "#{base_path}/#{part['slug']}"
        part
      end
    end

    def set_current_part(slug)
      @part_slug = slug
    end

    def next_part
      parts[current_part_index + 1]
    end

    def previous_part
      parts[current_part_index - 1] if current_part_index.positive?
    end

    def first_part?
      parts.any? && current_part == parts.first
    end

    def current_part_title
      current_part["title"]
    end

    def current_part_body
      current_part["body"] || ""
    end
  end

  def current_part
    if part_slug
      parts.find { |part| part["slug"] == part_slug }
    else
      parts.first
    end
  end

private

  def current_part_index
    parts.index(current_part)
  end

  def raw_parts
    content_store_response.dig("details", "parts") || []
  end
end
