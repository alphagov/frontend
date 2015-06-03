require 'test_helper'

class CrossDomainAnalyticsHelperTest < ActionView::TestCase
  include CrossDomainAnalyticsHelper

  context 'cross_domain_tracker' do
    should 'return a tracker account ID when the slug needs cross domain tracking enabled' do
      assert_equal 'UA-23066786-5', cross_domain_tracker('register-to-vote')
    end

    should 'returns nil when the slug has no cross domain tracking' do
      assert_equal nil, cross_domain_tracker('not-a-slug-with-tracking')
    end
  end
end
