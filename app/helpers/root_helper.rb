require 'geo_helper'

module RootHelper

  include GeoHelper

  def mustache_partial(template,context)
    filepath = "#{Rails.root}/app/views/root/#{template}.mustache"
    Mustache.render(File.read(filepath), context).html_safe
  end

  def mustache_direct(template)
    filepath = "#{Rails.root}/app/views/root/#{template}.mustache"
    File.read(filepath).html_safe
  end
end
