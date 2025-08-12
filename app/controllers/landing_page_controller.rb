class LandingPageController < ContentItemsController
  layout "full_width"

  content_security_policy do |policy|
    # The map block makes use of the OS api and inline styles
    policy.img_src(*policy.img_src, "https://api.os.uk", :data)
  end
end
