module Updatable
  extend ActiveSupport::Concern

  included do
    def any_updates?
      if public_updated_at && initial_publication_date
        Time.zone.parse(public_updated_at) != Time.zone.parse(initial_publication_date)
      else
        false
      end
    end

    def change_history
      content_store_hash.dig("details", "change_history") || []
    end

    def updated
      public_updated_at if any_updates?
    end

    def history
      return [] unless any_updates?

      reverse_chronological_change_history
    end

    def initial_publication_date
      first_public_at || first_published_at
    end
  end
end
