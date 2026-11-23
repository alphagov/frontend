GovukContentSecurityPolicy.configure do |policy|
  GovukPublishingComponents::AppHelpers::ContentSecurityPolicy.configure_policy_for_map(policy)
end
