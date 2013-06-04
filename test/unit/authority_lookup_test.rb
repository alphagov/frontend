require_relative '../test_helper'
require 'authority_lookup'

class AuthorityLookupTest < ActiveSupport::TestCase
  setup do
    AuthorityLookup.stubs(:authorities).returns({
      "example-authority" => {
        "ons" => "1",
        "gss" => "E10000001"
      },
      "another-authority" => {
        "ons" => "2",
        "gss" => "E10000002"
      }
    })
  end

  should "return the correct slug given a valid snac code as a string" do
    assert_equal "another-authority", AuthorityLookup.find_slug_from_snac('2')
  end

  should "return the correct slug given a valid snac code as an integer" do
    assert_equal "another-authority", AuthorityLookup.find_slug_from_snac(2)
  end

  should "return nil given a snac which doesn't exist" do
    assert_nil AuthorityLookup.find_slug_from_snac(12345)
  end

  should "return the correct slug given a valid gss code as a string" do
    assert_equal "example-authority", AuthorityLookup.find_slug_from_gss('E10000001')
  end

  should "return nil given a gss code which doesn't exist" do
    assert_nil AuthorityLookup.find_slug_from_gss('E12345678')
  end

  should "return the correct snac code given a valid slug" do
    assert_equal "1", AuthorityLookup.find_snac("example-authority")
  end

  should "return nil given a slug which doesn't exist" do
    assert_nil AuthorityLookup.find_snac("does-not-exist")
  end

  should "return the correct gss code given a valid slug" do
    assert_equal "E10000001", AuthorityLookup.find_gss("example-authority")
  end

  should "return nil given a gss which doesn't exist" do
    assert_nil AuthorityLookup.find_gss("does-not-exist")
  end
end
