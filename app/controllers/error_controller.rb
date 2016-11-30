class ErrorController < ApplicationController
  def handler
    # Our error is cached against the request object.
    content_api_cached_error = ArtefactRetrieverFactory.caching_artefact_retriever
    content_api_cached_error.set_request(request)

    # Individual error classes are handled in ApplicationController.
    raise content_api_cached_error.error
  end
end
