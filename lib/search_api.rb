class SearchAPI

  def initialize(rummager_api)
    @rummager_api = rummager_api
  end

  def search(search_params)
    Searcher.new(rummager_api, search_params).call
  end

private
  attr_reader :rummager_api

  class Searcher
    def initialize(api, params)
      @api = api
      @params = params
    end

    def call
      search_results.merge(scope_info)
    end

  private
    attr_reader :api, :params, :scope_object

    def search_results
      api.unified_search(rummager_params).to_hash
    end

    def scope_info
      if is_scoped? && scope_object.present?
        {
          "scope" => {
            "title" => scope_object.title,
          },
          "unscoped_results" => unscoped_results,
        }
      else
        {}
      end
    end

    def rummager_params
      params.rummager_parameters
    end

    def scope_object
      @scope_object ||= api.unified_search(filter_link: scope_object_link, count: "1", fields: %w{title}).results.first
    end

    def is_scoped?
      params.filtered_by?('manual')
    end

    def scope_object_link
      @scope_object_link ||= params.filter('manual').first
    end

    def unscoped_results
      @unscoped_results ||= api.unified_search(unscoped_rummager_request).to_hash
    end

    def unscoped_rummager_request
      rummager_params.except(:filter_manual).merge(count: "3", reject_manual: scope_object_link)
    end
  end
end
