class MissionsController < ApplicationController
  include Cacheable

  content_security_policy do |policy|
    # The map on this page makes use of the OS api and inline styles
    policy.img_src(*policy.img_src, "https://api.os.uk", :data)
  end

  def index; end
end
