class ArtefactRetriever
  class UnsupportedArtefactFormat < StandardError; end
  class RecordArchived < StandardError; end

  attr_accessor :supported_formats, :content_api, :logger, :statsd

  def initialize(content_api, logger, statsd, supported_formats = nil)
    self.content_api = content_api
    self.logger = logger
    self.statsd = statsd
    self.supported_formats = supported_formats ||
      %w{answer business_support completed_transaction guide help_page licence
         local_transaction place programme simple_smart_answer transaction 
         travel-advice video}
  end

  def fetch_artefact(slug, edition = nil, snac = nil, location = nil)
    artefact = content_api.artefact(slug, artefact_options(snac, location, edition))

    unless artefact
      logger.warn("Failed to fetch artefact #{slug} from Content API. Response code: 404")
      raise RecordNotFound
    end

    # The foreign-travel-advice override is necessary because it has a format of custom-application
    # and we don't want to add custom-application to supported formats, otherwise we get errors if
    # requests for other custom-applications hit frontend (e.g. business support finder on private-frontend).
    verify_format_supported?(artefact) unless slug == 'foreign-travel-advice'

    artefact
  rescue GdsApi::HTTPErrorResponse => e
    if e.code == 410
      raise RecordArchived
    elsif e.code >= 500
      statsd.increment("content_api_error")
    end
    raise
  rescue URI::InvalidURIError
    logger.warn("Failed to fetch artefact from Content API.")
    raise RecordNotFound
  end

  protected
    def verify_format_supported?(artefact)
      unless supported_formats.include?(artefact['format'])
        raise UnsupportedArtefactFormat
      end
    end

    def artefact_options(snac, location, edition)
      options = { snac: snac, edition: edition }.delete_if { |k,v| v.blank? }
      if location
        options[:latitude]  = location.lat
        options[:longitude] = location.lon
      end
      options
    end
end
