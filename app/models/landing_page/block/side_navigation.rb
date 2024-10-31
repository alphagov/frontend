module LandingPage::Block
  class SideNavigation < Base
    def links
      @links ||= landing_page.navigation_groups[data["navigation_group_id"]]["links"]
    end
  end
end
