module Organisations
    extend ActiveSupport::Concern
  
    included do
      def linkable_organisations
        organisation_links_with_emphasis
      end
    end
  
  private
  
    def organisation_links_with_emphasis
      expanded_organisations.sort_by { |link| emphasised?(link) ? -1 : 1 }
    end
  
    def expanded_organisations
      content_store_hash.dig("links", "organisations") || []
    end
  
    def emphasised?(link)
      link["content_id"].in?(emphasised_organisations)
    end
  
    def emphasised_organisations
      content_store_hash.dig("details", "emphasised_organisations") || []
    end
  end