module Political
  extend ActiveSupport::Concern

  included do
    def historically_political?
      political? && historical?
    end

    def publishing_government
      content_store_response.dig(
        "links", "government", 0, "title"
      )
    end
  end

private

  def political?
    content_store_response.dig("details", "political")
  end

  def historical?
    government_current = content_store_response.dig(
      "links", "government", 0, "details", "current"
    )

    # Treat no government as not historical
    return false if government_current.nil?

    !government_current
  end
end
