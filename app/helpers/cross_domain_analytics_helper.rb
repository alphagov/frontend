module CrossDomainAnalyticsHelper
  def cross_domain_tracker(slug)
    {
      'register-to-vote' => 'UA-23066786-5',
      'accelerated-possession-eviction' => 'UA-37377084-12',
      'renewtaxcredits' => 'UA-43414424-1', # HMRC, https://www.pivotaltracker.com/n/projects/1261204
    }[slug]
  end
end
