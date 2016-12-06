class ContentApiErrorRoutingConstraint
  def initialize(artefact_retriever: ArtefactRetrieverFactory.caching_artefact_retriever)
    @artefact_retriever = artefact_retriever
  end

  def matches?(request)
    @artefact_retriever.set_request(request)
    @artefact_retriever.error?
  end
end
