class SpecialistDocument < ContentItem
  attr_reader :continuation_link, :headers, :will_continue_on

  def initialize(content_store_response)
    super(content_store_response)

    @continuation_link = content_store_hash.dig("details", "metadata", "continuation_link")
    @will_continue_on = content_store_hash.dig("details", "metadata", "will_continue_on")

    @headers = headers_list(content_store_hash.dig("details", "headers"))
  end

private

  def headers_list(headers)
    return if headers.blank?

    headers.map do |header|
      h = {
        href: "##{header['id']}",
        text: header["text"].gsub(/:$/, ""),
        level: header["level"],
      }

      if header["headers"]
        h[:items] = headers_list(header["headers"])
      end

      h
    end
  end
end
