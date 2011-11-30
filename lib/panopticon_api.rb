require 'gds_api'

class PanopticonApi < GdsApi

  def artefact_for_slug(slug)
    return nil if slug.blank?
    
    to_ostruct get_json(url_for_slug(slug))
  end

  private
    def base_url
      "#{endpoint}/artefacts"
    end
end
