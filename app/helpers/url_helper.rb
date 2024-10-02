module UrlHelper
  def canonical_url(path)
    Plek.new.website_root + path
  end
end
