module JsonUtils
  def get_json(url)
    url = URI.parse(url)
    response = Net::HTTP.start(url.host, url.port) do |http|
      request = url.path
      request = request + "?" + url.query if url.query
      http.get(request)
    end
    if response.code.to_i != 200
      return nil
    else
      return JSON.parse(response.body)
    end
  end
  
  def post_json(url,params)
    url = URI.parse(url)
    Net::HTTP.start(url.host, url.port) do |http|
      post_response = http.post(url.path, params.to_json, {'Content-Type' => 'application/json'})
      if post_response.code == '200'
        return JSON.parse(post_response.body)
      end
    end
    return nil
  end

end


