class FormatRoutingConstraint
  def initialize(format, artefact_retriever: ArtefactRetrieverFactory.caching_artefact_retriever)
    @format = format
    @caching_artefact_retriever = artefact_retriever
  end

  def matches?(request)
    @caching_artefact_retriever.set_request(request)
    slug = request.params.fetch(:slug)
    edition = request.params.fetch(:edition, nil)
    artefact = @caching_artefact_retriever.fetch_artefact(slug, edition)
    artefact.format == @format if artefact && artefact.respond_to?(:format)
  end
end
