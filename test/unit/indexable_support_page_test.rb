require_relative '../test_helper'
require 'indexable_support_page'

class IndexableSupportPageTest < ActiveSupport::TestCase

  should "use the h1 for the title" do
    filename = "#{Rails.root}/app/views/support/about-govuk.html.erb"
    isp = IndexableSupportPage.new(filename)
    assert_equal "About GOV.UK", isp.title
  end

  should "use the meta description for the description"

  should "fallback to blank when no meta description" do
    filename = "#{Rails.root}/app/views/support/about-govuk.html.erb"
    isp = IndexableSupportPage.new(filename)
    assert_equal nil, isp.description
  end

  should "use 'support_page' for format" do
    filename = "#{Rails.root}/app/views/support/about-govuk.html.erb"
    isp = IndexableSupportPage.new(filename)
    assert_equal "support_page", isp.format
  end

  should "use the filename without extension for the link" do
    filename = "#{Rails.root}/app/views/support/about-govuk.html.erb"
    isp = IndexableSupportPage.new(filename)
    assert_equal "/support/about-govuk", isp.link
  end

  should "cope when the filename has just .erb, not html.erb" do
    filename = "#{Rails.root}/app/views/support/linking-to-govuk.erb"
    isp = IndexableSupportPage.new(filename)
    assert_equal "/support/linking-to-govuk", isp.link
  end

  should "use the text of the page with erb and HTML removed for indexable_content" do
    filename = "#{Rails.root}/app/views/support/about-govuk.html.erb"
    isp = IndexableSupportPage.new(filename)
    assert_match(/^About GOV.UK\s+On this page:/m, isp.indexable_content)
  end
end
