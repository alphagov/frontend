module LandingPage::Block
  class SideNavigation < Base
    LINKS_FILE_PATH = "lib/data/landing_page_content_items/links/side_navigation.yaml".freeze

    def links
      file_path = Rails.root.join(LINKS_FILE_PATH)
      YAML.load(File.read(file_path))
    end
  end
end
