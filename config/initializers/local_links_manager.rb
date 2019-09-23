require "gds_api/local_links_manager"

Frontend.local_links_manager_api = GdsApi::LocalLinksManager.new(Plek.new.find("local-links-manager"))
