module LandingPage::Block
  class MainNavigation < Base
    attr_reader :name, :links

    def initialize(block_hash, landing_page)
      super

      navigation_group = landing_page.navigation_groups[data["navigation_group_id"]]
      @name = navigation_group["name"]
      @links = navigation_group["links"]
    end

    def full_width?
      true
    end
  end
end
