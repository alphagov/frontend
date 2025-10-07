class Webchat < ContentItem
  attr_reader :availability_url, :csp_connect_src, :ga4_link_data, :open_url, :redirect_attribute

  def initialize(content_store_response)
    super

    @availability_url = "https://d1y02qp19gjy8q.cloudfront.net/availability/18555309"
    @csp_connect_src = "https://d1y02qp19gjy8q.cloudfront.net"
    @ga4_link_data = {
      event_name: "navigation",
      type: "webchat",
      text: I18n.t("webchat.speak_to_adviser", locale: :en),
    }.to_json
    @open_url = "https://d1y02qp19gjy8q.cloudfront.net/open/index.html"
    @redirect_attribute = "false"
  end

  def lead_paragraph
    nil
  end
end
