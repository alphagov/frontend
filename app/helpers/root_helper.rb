module RootHelper

  def guide_path(slug,part,edition)
    if edition
      publication_path(:slug=>slug,:part=>part,:edition=>edition) 
    else
      publication_path(:slug=>slug,:part=>part) 
    end
  end
end
