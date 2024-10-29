module LandingPage::Block
  class MainNavigation < Base
    attr_reader :links

    def initialize(block_hash, landing_page)
      super

      navigation_group = landing_page.navigation_groups[data["navigation_group_id"]]
      @links = navigation_group["links"]
    end

    def full_width?
      true
    end
  end
end
