require_relative '../test_helper'
require "indexable_support_page_set"

class IndexableSupportPageSetTest < ActiveSupport::TestCase
  should "be able to generate hashes for each support page without error" do
    pages = IndexableSupportPageSet.new.pages
    assert pages.size > 0, "No pages found. Suspicious."
    pages.each do |page|
      hash = page.to_hash
      ["title", "format", "link", "indexable_content"].each do |field| #"description"
        assert_not_nil(hash[field], "Didn't get a #{field} for #{page.filename}")
      end
    end
  end
end
