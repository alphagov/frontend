require_relative '../test_helper'
require 'indexable_support_page'

class IndexableSupportPageTest < ActiveSupport::TestCase

  should "use the h1 for the title" do
    filename = "#{Rails.root}/app/views/support/about-govuk.html.erb"
    isp = IndexableSupportPage.new(filename)
    assert_equal "About GOV.UK", isp.title
  end

  should "use the meta description for the description" do
    filename = "#{Rails.root}/app/views/support/about-govuk.html.erb"
    isp = IndexableSupportPage.new(filename)
    expected = "GOV.UK linking policy, data sets, analytics and monitoring and republishing information on GOV.UK under the Open Goverment Licence"
    assert_equal expected, isp.description
  end

  should "use 'support_page' for format" do
    filename = "#{Rails.root}/app/views/support/about-govuk.html.erb"
    isp = IndexableSupportPage.new(filename)
    assert_equal "support_page", isp.format
  end

  should "use 'Support' for the section" do
    filename = "#{Rails.root}/app/views/support/about-govuk.html.erb"
    isp = IndexableSupportPage.new(filename)
    assert_equal "Support", isp.section
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
