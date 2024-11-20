module LandingPage::Block
  class PressNotices < Base
    def full_width?
      false
    end

    def items
      data.fetch("items").map do |i|
        {
          link: {
            text: i["text"],
            path: i["href"],
          },
          metadata: {
            public_updated_at: Time.zone.parse(i["public_updated_at"]),
            document_type: i["document_type"],
          },
        }
      end
    end
  end
end
