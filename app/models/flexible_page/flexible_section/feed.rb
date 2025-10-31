module FlexiblePage::FlexibleSection
  class Feed < Base
    attr_reader :context, :email_signup_link, :feed_heading_text, :see_all_items_link, :share_links_heading_text

    def initialize(flexible_section_hash, content_item)
      super

      @context = flexible_section_hash["context"]
      @feed_heading_text = flexible_section_hash["feed_heading_text"]

      @share_links_heading_text = flexible_section_hash["share_links_heading_text"]
      @share_links = flexible_section_hash["share_links"]

      @email_signup_link = flexible_section_hash["email_signup_link"]

      @see_all_items_link = flexible_section_hash["see_all_items_link"]
    end

    def items
      flexible_section_hash["items"].map do |i|
        {
          link: {
            text: i["link"]["text"],
            path: i["link"]["path"],
          },
          metadata: {
            public_updated_at: Time.zone.parse(i["metadata"]["public_updated_at"] || ""),
            document_type: i["metadata"]["document_type"],
          },
        }
      end
    end

    def share_links
      flexible_section_hash["share_links"].map do |i|
        {
          href: i["href"],
          text: i["text"],
          icon: i["icon"],
          data_attributes: i["data_attributes"],
        }
      end
    end
  end
end
