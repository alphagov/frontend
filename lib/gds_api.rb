require 'json_utils'
require 'net/http'
require 'ostruct'
require 'core-ext/openstruct'

class GdsApi
  include JsonUtils

  def initialize(endpoint)
    self.endpoint = endpoint
  end
  
  def url_for_slug(slug,options={})
    base = "#{base_url}/#{slug}.json"
    params = options.map { |k,v| "#{k}=#{v}" }
    base = base + "?#{params.join("&")}" unless options.empty? 
    base
  end
  
  private
    attr_accessor :endpoint
end