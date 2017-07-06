# coding: utf-8
class SearchResult
  include ActionView::Helpers::NumberHelper
  SCHEME_PATTERN = %r{^https?://}

  attr_accessor :result

  def initialize(search_parameters, result)
    @search_parameters = search_parameters
    @result = result.stringify_keys!
  end

  def ==(other)
    other.respond_to?(:link) && (link == other.link)
  end

  def self.result_accessor(*keys)
    keys.each do |key|
      define_method key do
        result[key.to_s]
      end
    end
  end

  result_accessor :link, :title, :format, :es_score, :public_timestamp

  # External links have a truncated version of their URLs displayed on the
  # results page, but there's little benefit to displaying the URL scheme
  def display_link
    link.sub(SCHEME_PATTERN, '').truncate(48) if link
  end

  def debug_score
    @search_parameters.debug_score
  end

  def to_hash
    {
      debug_score: debug_score,
      link: link,
      examples_present?: result["examples"].present?,
      carers_allowance?: link.end_with?("/carers-allowance"),
      show_result?: show_result?(link),
      examples: result["examples"],
      description_with_highlighting: result["description_with_highlighting"],
      title_with_highlighting: result["title_with_highlighting"],
      suggested_filter_present?: result["suggested_filter"].present?,
      suggested_filter_title: suggested_filter_title,
      suggested_filter_link: suggested_filter_link,
      external: format == "recommended-link",
      display_link: display_link,
      attributes: [],
      es_score: formatted_es_score,
      format: format,
      is_multiple_results: false,
      content_id: result["content_id"],
    }
  end

protected

  def show_result?(link)
    blacklist = %w(
      /carers-allowance-report-change
      /carers-allowance-unit
    )

    return false if blacklist.any? { |b| link.include?(b) }
    true
  end

  def suggested_filter_title
    suggested_filter = result["suggested_filter"]
    if suggested_filter
      count = suggested_filter["count"]
      name = suggested_filter["name"]
      %{All #{count} results in "#{name}"}
    end
  end

  def suggested_filter_link
    suggested_filter = result["suggested_filter"]
    if suggested_filter
      field = suggested_filter["field"]
      value = suggested_filter["value"]
      @search_parameters.build_link(
        "filter_#{field}" => value
      )
    end
  end

  def formatted_es_score
    number_with_precision(es_score * 1000, significant: true, precision: 4) if es_score
  end

  def humanized_name(name)
    name.gsub('-', ' ').capitalize
  end
end
