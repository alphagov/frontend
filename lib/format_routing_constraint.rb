class FormatRoutingConstraint
  def initialize(format, artefact_retriever: ArtefactRetrieverFactory.artefact_retriever)
    @format = format
    @artefact_retriever = artefact_retriever
  end

  def matches?(request)
    slug = request.params.fetch(:slug)
    edition = request.params.fetch(:edition, nil)
    artefact = cacheable_artefact(slug, edition, request)
    artefact.format == @format if artefact && artefact.respond_to?(:format)
  end

  private

  def cacheable_artefact(slug, edition, request)
    request.env[:__artefact_cache] ||= {}
    request.env[:__artefact_cache][slug] ||=
      @artefact_retriever.fetch_artefact(slug, edition)
  rescue
    nil
  end
end
