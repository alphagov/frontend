# This file is overwritten during deployment
#
# Boolean indicating whether or not to enable a Content-Security-Policy
# header in this application.
#
if Rails.env.development? or Rails.env.test?
  Frontend::Application.config.enable_csp = true
else
  Frontend::Application.config.enable_csp = false
end
