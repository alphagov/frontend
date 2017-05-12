require 'services'

class SearchAPI
  def initialize(params, ab_tests = {})
    @params = params
    @ab_tests = ab_tests.map { |name, type| "#{name}:#{type}" }.join(',')
  end

  def search
    search_results.merge(scope_info)
  end

private

  attr_reader :params, :ab_tests

  def search_results
    Services.rummager.search(rummager_params).to_hash
  end

  # If the user is in scoped-search mode inside a manual, then return the manual
  # we're scoping to and the unscoped results.
  def scope_info
    if is_scoped? && scoped_manual.present?
      {
        "scope" => {
          "title" => scoped_manual.to_hash.fetch("title", ""),
        },
        "unscoped_results" => unscoped_results,
      }
    else
      {}
    end
  end

  def rummager_params
    params.rummager_parameters.merge(ab_tests: ab_tests)
  end

  def scoped_manual
    @scoped_manual ||= Services.rummager.search(filter_link: manual_link, count: "1", fields: %w{title})
    @scoped_manual.to_hash.fetch("results", []).first
  end

  def is_scoped?
    params.filtered_by?('manual')
  end

  def manual_link
    @manual_link ||= params.filter('manual').first
  end

  def unscoped_results
    @unscoped_results ||= Services.rummager.search(unscoped_rummager_request).to_hash
  end

  def unscoped_rummager_request
    rummager_params.except(:filter_manual).merge(count: "3", reject_manual: manual_link)
  end
end
