module FlexiblePage::FlexibleSection
  class Feed < Base
    attr_reader :email_signup_link, :email_signup_link_text,
                :feed_heading_text, :see_all_items_link, :share_links, :share_links_heading_text

    def initialize(flexible_section_hash, content_item)
      super

      @feed_heading_text = flexible_section_hash["feed_heading_text"]

      @share_links_heading_text = flexible_section_hash["share_links_heading_text"]
      @share_links = flexible_section_hash["share_links"] || []

      @email_signup_link = flexible_section_hash["email_signup_link"]
      @email_signup_link_text = flexible_section_hash["email_signup_link_text"]

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
  end
end
