module LandingPage::Block
  class MainNavigation < Base
    attr_reader :name, :links

    def initialize(block_hash, landing_page)
      super

      nav_group_id = data["navigation_group_id"]
      raise "Main Navigation block points to a missing navigation group: #{nav_group_id}" unless landing_page.navigation_groups.key?(nav_group_id)

      navigation_group = landing_page.navigation_groups[nav_group_id]
      @name = navigation_group["name"]
      @links = navigation_group["links"]
    end

    def full_width?
      true
    end
  end
end
