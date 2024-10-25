module Block
  class MainNavigation < Block::Base
    attr_reader :title, :title_link, :links

    def initialize(block_hash, landing_page)
      super

      @title = block_hash.fetch("title")
      @title_link = block_hash.fetch("title_link")
      @links = documents(block_hash.fetch("collection_group_name"))
    end

    def full_width?
      true
    end

    def documents(collection_group_name)
      landing_page.collection_groups[collection_group_name]&.documents
    end
  end
end
