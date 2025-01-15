module WorldwideOrganisations
  extend ActiveSupport::Concern

  included do
    def worldwide_organisations
      content_store_hash.dig("links", "worldwide_organisations") || []
    end
  end
end
