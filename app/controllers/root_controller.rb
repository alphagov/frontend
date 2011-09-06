class RecordNotFound < Exception
end

class RootController < ApplicationController
  def index
    #@items = api.publications
  end

  def publication
    @slug, @partslug = params[:slug], params[:part]
    @publication = api.publication_for_slug(@slug)
    assert_found(@publication)
    instance_variable_set("@#{@publication.type}".to_sym,@publication)
    if @publication.parts
       @part = pick_part(@partslug,@publication)
       assert_found(@part)
    end
    render @publication.type 
  rescue RecordNotFound
    render :status=>404
  end

  protected
  def assert_found(obj)
    raise RecordNotFound unless obj
  end

  def pick_part(partslug,pub)
     if partslug
        pub.find_part(partslug)
     else
        pub.parts.first
     end
  end
end
