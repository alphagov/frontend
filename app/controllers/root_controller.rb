class RecordNotFound < Exception
end

class RootController < ApplicationController
  def index
    #@items = api.publications
  end

  def publication
    @slug, @partslug = params[:slug], params[:part]
    @edition = params[:edition]
    @publication = api.publication_for_slug(@slug,@edition)
    assert_found(@publication)
    instance_variable_set("@#{@publication.type}".to_sym,@publication)
    if @publication.parts
       @part = pick_part(@partslug,@publication)
       assert_found(@part)
    end
    render @publication.type 
  rescue RecordNotFound
    render :file => "#{Rails.root}/public/404.html", :layout=>nil, :status=>404
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
