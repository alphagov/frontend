module FlexiblePage::FlexibleSection
  class DocumentList < Base
    attr_reader :email_signup_link, :email_signup_link_text,
                :heading_text, :items,
                :see_all_items_link, :see_all_items_link_text

    def initialize(email_signup_link:, email_signup_link_text:, heading_text:, see_all_items_link:, see_all_items_link_text:, items: [])
      super

      @email_signup_link = email_signup_link
      @email_signup_link_text = email_signup_link_text
      @heading_text = heading_text
      @see_all_items_link = see_all_items_link
      @see_all_items_link_text = see_all_items_link_text

      @items = strip_metadata_fields(items)
    end

  private

    def strip_metadata_fields(items_hash)
      items_hash.map do |i|
        {
          link: i[:link],
          metadata: i[:metadata].except(:display_type, :description),
        }
      end
    end
  end
end
