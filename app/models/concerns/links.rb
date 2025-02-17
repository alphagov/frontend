module Links
  extend ActiveSupport::Concern

  included do
    def links(type)
      (content_store_hash.dig("links", type.to_s) || []).map do |link|
        ContentItemFactory.build(link)
      end
    end

    def available_translations
      links(:available_translations).sort_by { |t| t["locale"] == I18n.default_locale.to_s ? "" : t["locale"] }
    end

    # Metaprogramming: call with has_link :field_of_operation to define a
    # method `field_of_operation` which returns the first link of that
    # type. Use if the link has maxItems: 1
    def has_link(link_type)
      define_method(link_type) do
        links(type).first
      end
    end

    # Metaprogramming: call with has_links :available_transaltions to
    # define a method `available_translations` which returns all links
    # of that type. Use if the link does not have maxItems: 1
    def has_links(link_type)
      define_method(link_type) do
        links(type)
      end
    end
  end
end