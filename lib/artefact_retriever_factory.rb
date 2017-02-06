class ArtefactRetrieverFactory
  class << self
    def artefact_retriever(
      options: {},
      artefact_retriever_class: ArtefactRetriever
    )

      @options = options
      artefact_retriever_class.new(content_api, logger, statsd)
    end

  private

    def content_api
      GdsApi::ContentApi.new(
        Plek.new.find("contentapi"),
        content_api_options
      )
    end

    def content_api_options
      CONTENT_API_CREDENTIALS.merge(@options)
    end

    def logger
      Rails.logger
    end

    def statsd
      Statsd.new("localhost").tap do |c|
        c.namespace = ENV['GOVUK_STATSD_PREFIX'].to_s
      end
    end
  end
end
