class ArtefactRetriever
  class UnsupportedArtefactFormat < StandardError; end
  class RecordArchived < StandardError; end
  class RecordNotFound < StandardError; end

  attr_accessor :supported_formats, :content_api, :logger, :statsd

  def initialize(content_api, logger, statsd, supported_formats = nil)
    self.content_api = content_api
    self.logger = logger
    self.statsd = statsd
    self.supported_formats = supported_formats ||
      %w{answer business_support completed_transaction guide help_page licence
         local_transaction place simple_smart_answer transaction travel-advice}
  end

  def fetch_artefact(slug, edition = nil, snac = nil)
    content_api.artefact!(slug, artefact_options(snac, edition))
  rescue GdsApi::HTTPNotFound
    logger.warn("Failed to fetch artefact #{slug} from Content API. Response code: 404")
    raise RecordNotFound
  rescue GdsApi::HTTPGone
    raise RecordArchived
  rescue GdsApi::HTTPErrorResponse => e
    if e.code && e.code >= 500
      statsd.increment("content_api_error")
    end
    raise
  rescue URI::InvalidURIError
    logger.warn("Failed to fetch artefact from Content API.")
    raise RecordNotFound
  end

  protected

  def artefact_options(snac, edition)
    { snac: snac, edition: edition }.delete_if { |k, v| v.blank? }
  end
end
