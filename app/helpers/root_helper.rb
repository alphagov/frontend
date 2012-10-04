require 'geo_helper'

module RootHelper

  include GeoHelper

  def has_further_information?(publication)
    publication.parts.collect(&:slug).include?('further-information')
  end

  def programme_parts(publication)
    publication.parts.reject { |part| part.slug == 'further-information' }
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
