require 'services'

class SearchAPI
  def search(params)
    @params = params
    search_results.merge(scope_info)
  end

private

  attr_reader :params

  def search_results
    Services.rummager.search(rummager_params).to_hash
  end

  def scope_info
    if is_scoped? && scope_object.present?
      {
        "scope" => {
          "title" => scope_object.to_hash.fetch("title", ""),
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
    @_scope_object ||= Services.rummager.search(filter_link: scope_object_link, count: "1", fields: %w{title})
    @_scope_object.to_hash.fetch("results", []).first
  end

  def is_scoped?
    params.filtered_by?('manual')
  end

  def scope_object_link
    @scope_object_link ||= params.filter('manual').first
  end

  def unscoped_results
    @unscoped_results ||= Services.rummager.search(unscoped_rummager_request).to_hash
  end

  def unscoped_rummager_request
    rummager_params.except(:filter_manual).merge(count: "3", reject_manual: scope_object_link)
  end
end
