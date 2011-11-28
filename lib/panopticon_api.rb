require 'json_utils'

class PanopticonApi
  include JsonUtils

  def initialize(endpoint)
    self.endpoint = endpoint
  end

  def artefact_for_slug(slug)
    to_ostruct get_json(url_for_slug(slug))
  end

  def url_for_slug(slug)
    "#{base_url}/#{slug}.js" # TODO change to .json in panopticon
  end

  private
    attr_accessor :endpoint

    def base_url
      "#{endpoint}/artefacts"
    end

    def to_ostruct(object)
      case object
      when Hash
        OpenStruct.new Hash[object.map { |key, value| [key, to_ostruct(value)] }]
      when Array
        object.map { |k| to_ostruct(k) }
      else
        object
      end
    end
end
