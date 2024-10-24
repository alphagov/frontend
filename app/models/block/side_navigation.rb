module Block
  class SideNavigation < Block::Base
    def links
      landing_page.collection_groups["Side navigation"].documents
    end
  end
end
