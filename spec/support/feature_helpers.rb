module FeatureHelpers
  def assert_current_url(path_with_query, options = {})
    expected = URI.parse(path_with_query)
    current = URI.parse(current_url)
    assert_equal expected.path, current.path
    unless options[:ignore_query]
      assert_equal Rack::Utils.parse_query(expected.query), Rack::Utils.parse_query(current.query)
    end
  end
end
