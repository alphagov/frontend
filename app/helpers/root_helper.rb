require 'geo_helper'

module RootHelper
  
  include GeoHelper
  def guide_path(slug,part,edition)
    if edition
      publication_path(:slug=>slug,:part=>part,:edition=>edition) 
    else
      publication_path(:slug=>slug,:part=>part) 
    end
  end

  def part_number(parts, part)
    parts.index(part) + 1
  end

  def transaction_path(slug,council,edition)
    unless council
      guide_path(slug,nil,edition)
    else
      if edition
        publication_path(:slug=>slug,:edition=>edition,:snac=>council)
      else
        publication_path(:slug=>slug,:snac=>council)
      end
    end
  end

  def council_lookup_path(slug)
    identify_council_path(:slug=>slug) 
  end

  def to_govspeak(field)
    Govspeak::Document.new(field || "", :auto_ids=>false).to_html.html_safe
  end

  def mustache_partial(template,context)
    filepath = "#{Rails.root}/app/views/root/#{template}.mustache"
    Mustache.render(File.read(filepath), context).html_safe
  end

  def mustache_direct(template)
    filepath = "#{Rails.root}/app/views/root/#{template}.mustache"
    File.read(filepath).html_safe
  end
end
