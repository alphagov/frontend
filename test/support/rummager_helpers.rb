class ActiveSupport::TestCase
  def stub_search_to_return_results_scoped_to_manual
    stub_request(:get, %r{/search.json.*filter_manual.*}).to_return(body: manual_scoped_search)
  end

  def stub_scope_object
    stub_request(:get, %r{/search.json.*filter_link.*}).to_return(body: scoped_object)
  end

  def stub_unscoped_search(query)
    stub_request(:get, /search.json.*q=#{Regexp.quote(query)}.*/).to_return(body: search_result(query))
  end

private

  def search_result(query)
    fixture_data("unscoped_search_results_for_#{query}.json")
  end

  def stub_search_page_in_content_store
    content_store_has_item("/search", schema: 'special_route')
  end

  def stub_any_rummager_search
    endpoint = Plek.current.find('search')
    stub_request(:get, %r{#{endpoint}/search.json})
  end

  def scoped_object
    fixture_data('manual_scoped_search_scope_object.json')
  end

  def unscoped_object
    fixture_data('manual_unscoped_search.json')
  end

  def manual_scoped_search
    fixture_data('manual_scoped_search_results.json')
  end

  def fixture_data(filename)
    File.read(Rails.root.join("test/fixtures/#{filename}"))
  end
end
