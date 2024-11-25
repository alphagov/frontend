class ErrorController < ApplicationController
  def handler
    # We know at this point that the ContentItemLoader has stored
    # an exception to deal with, so just retrieve it and raise it
    # to be handled in ApplicationController
    raise ContentItemLoader.for_request(request).load(request.path)
  end
end
