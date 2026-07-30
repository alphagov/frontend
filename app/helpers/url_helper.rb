module UrlHelper
  def add_parameter_if_present(url, parameter)
    return url if params[parameter].nil?

    parsed_url = URI.parse(url)
    new_query_array = URI.decode_www_form(parsed_url.query || "") << [parameter, params[parameter]]
    parsed_url.query = URI.encode_www_form(new_query_array)
    parsed_url.to_s
  end

  def canonical_url(path)
    Plek.new.website_root + path
  end
end
