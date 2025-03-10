module People
  extend ActiveSupport::Concern

  included do
    def people
      linked("people")
    end
  end
end
