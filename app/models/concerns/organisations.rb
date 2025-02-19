module Organisations
  extend ActiveSupport::Concern

  included do
    def organisations_ordered_by_emphasis
      organisations.sort_by { |organisation| emphasised?(organisation) ? -1 : 1 }
    end

    def organisations
      content_store_hash.dig("links", "organisations") || []
    end
  end

private

  def emphasised?(organisation)
    organisation["content_id"].in?(emphasised_organisations)
  end

  def emphasised_organisations
    content_store_hash.dig("details", "emphasised_organisations") || []
  end
end
