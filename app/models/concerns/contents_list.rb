module ContentsList
  extend ActiveSupport::Concern

  included do
    def contents
      @contents ||=
        if contents_items.present?
          contents_items.each { |item| item[:href] = "##{item[:id]}" }
        else
          []
        end
    end

    def contents_items
      extract_headings_with_ids
    end

  private

    def extract_headings_with_ids
      @headings ||= parsed_body.css("h2").map do |heading|
        id = heading.attribute("id")
        { text: heading.text.gsub(/:$/, ""), id: id.value } if id
      end
      @headings.compact
    end

    def parsed_body
      @parsed_body ||= Nokogiri::HTML(body)
    end
  end
end
