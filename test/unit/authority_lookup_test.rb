require 'test_helper'
require 'authority_lookup'

class AuthorityLookupTest < ActiveSupport::TestCase
  setup do
    AuthorityLookup.stubs(:authorities).returns({
      "example-authority" => "1",
      "another-authority" => "2"
    })
  end

  should "return the correct snac code given a valid slug" do
    assert_equal "1", AuthorityLookup.find_snac("example-authority")
  end

  should "return the correct slug given a valid snac code as a string" do
    assert_equal "another-authority", AuthorityLookup.find_slug('2')
  end

  should "return the correct slug given a valid snac code as an integer" do
    assert_equal "another-authority", AuthorityLookup.find_slug(2)
  end

  should "return false given a slug which doesn't exist" do
    assert_false AuthorityLookup.find_snac("does-not-exist")
  end

  should "return false given a snac which doesn't exist" do
    assert_false AuthorityLookup.find_slug(12345)
  end
end
