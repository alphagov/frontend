# frozen_string_literal: true

class TransactionGraphqlPresenter < SimpleDelegator
  delegate :format, to: :schema_name
  def tab_count
    [more_information, what_you_need_to_know, other_ways_to_apply].count(&:present?)
  end

  def multiple_more_information_sections?
    tab_count > 1
  end

  def short_description
    nil
  end

  def in_beta
    phase == "beta"
  end

  def format
    false
  end

  def slug
    URI.parse(base_path).path.sub(%r{\A/}, "")
  end
end
