class RootController < ApplicationController
  def index
    #@items = api.publications
  end

  def publication
    @slug, @part = params[:slug], params[:part]
    @publication = api.publication_for_slug(@slug)
    if @publication
      instance_variable_set("@#{@publication.type}".to_sym,@publication)
      render @publication.type 
    else
      render :status => 404
    end
  end
end
