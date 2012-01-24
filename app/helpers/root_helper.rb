require 'geo_helper'

module RootHelper

  include GeoHelper
  def guide_path(slug, part=nil, edition=nil)
    opts = Hash[{slug: slug, part: part, edition: edition}.select { |k,v| v }]
    publication_path(opts)
  end

  def easter_egg(path)
    partial_path = Rails.env.test? ? "test/fixtures" : "lib/data"
    json_path = Rails.root.join(partial_path, "eastereggs.json")
    data = JSON.parse(File.read(json_path))
    content = data[path]
    content ? "<!-- #{content} -->".html_safe : ""
  end

  def has_further_information?(publication)
    publication.parts.collect(&:slug).include?('further-information')
  end

  def programme_parts(publication)
    publication.parts.reject { |part| part.slug == 'further-information' }
  end

  def part_number(parts, part)
    parts.index(part) + 1
  rescue => e
    Rails.logger.info "#{e.message} : #{parts.inspect} : #{part.inspect}"
    "-"
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

  def video_embed_url(guide)
    video = guide.video_url.scan(/\?v=([A-Za-z0-9_\-]+)/)
    if video.any?
      "http://www.youtube.com/watch?v=#{video[0][0]}"
    else
      ""
    end
  end
end
