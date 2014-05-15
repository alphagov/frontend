require 'gds_api/external_link_tracker'
require 'logger'

class ExternalLinkRegisterer
  attr_reader :logger

  def initialize(logger = default_logger)
    @logger = logger
  end

  def register_links(links)
    logger.info "Registering #{links.count} links with external link tracker..."

    links.each do |link|
      api.add_external_link(link)
    end

    logger.info 'External links registered'
  end

private
  def api
    @api ||= GdsApi::ExternalLinkTracker.new(Plek.current.find('api-external-link-tracker'))
  end

  def default_logger
    Logger.new('/dev/null')
  end
end
