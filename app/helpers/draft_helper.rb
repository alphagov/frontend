module DraftHelper
  def draft_host?
    ENV["PLEK_HOSTNAME_PREFIX"] == "draft-"
  end
end
