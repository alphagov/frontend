class RequestMissingException < NotImplementedError; end

class ArtefactRetrieverWithRequestCache
  def initialize(artefact_retriever: ArtefactRetrieverFactory.artefact_retriever)
    @artefact_retriever = artefact_retriever
  end

  def set_request(request)
    @request = request
  end

  def fetch_artefact(slug, edition = nil)
    raise RequestMissingException if @request.nil?
    return false if error?

    begin
      cache_artefact slug, edition
    rescue => err
      cache_error err
      false
    end
  end

  def error
    return nil unless error?

    err = @request.env[:__error_cache]

    # Ensure that the stacktrace is correct for the new object context.
    # Trust me, you *really* don't want to be debugging an issue with the
    # wrong stacktrace.
    backtrace = Kernel.caller
    err.define_singleton_method(:backtrace) { backtrace }

    err
  end

  def error?
    @request.env[:__error_cache].present?
  end

private

  def cache_artefact(slug, edition)
    @request.env[:__artefact_cache] ||= {}
    @request.env[:__artefact_cache][slug] ||=
      @artefact_retriever.fetch_artefact(slug, edition)
  end

  def cache_error(err)
    @request.env[:__error_cache] = err
  end
end
