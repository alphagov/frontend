require "uri"

module LinksHelper
  def extract_host(url)
    URI.parse(url).host
  end
end
