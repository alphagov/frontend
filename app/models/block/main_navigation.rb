module Block
  class MainNavigation < Block::Base
    attr_reader :title, :title_link, :links

    def initialize(block_hash, landing_page)
      super

      @title = top_menu_document_collection.first["text"]
      @title_link = top_menu_document_collection.first["href"]
      @links = top_menu_document_collection[1..]
    end

    def full_width?
      true
    end

    def top_menu_document_collection
      landing_page.collection_groups["Top menu"].documents
    end
  end
end
