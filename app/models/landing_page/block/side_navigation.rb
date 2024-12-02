module LandingPage::Block
  class SideNavigation < Base
    attr_reader :links

    def initialize(block_hash, landing_page)
      super

      nav_group_id = data["navigation_group_id"]
      raise "Side Navigation block points to a missing navigation group: #{nav_group_id}" unless landing_page.navigation_groups.key?(nav_group_id)

      @links = landing_page.navigation_groups[nav_group_id]["links"]
    end
  end
end
