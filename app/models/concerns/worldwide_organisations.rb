module WorldwideOrganisations
  extend ActiveSupport::Concern

  included do
    def worldwide_organisations
      (content_store_hash.dig("links", "worldwide_organisations") || []).map do |organisation|
        { "title" => organisation["title"], "base_path" => organisation["base_path"], "content_id" => organisation["content_id"] }
      end
    end
  end
end
