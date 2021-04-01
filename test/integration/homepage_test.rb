require "integration_test_helper"

class HomepageTest < ActionDispatch::IntegrationTest
  setup do
    @organisations_payload = {
      organisation_payload: "/government/organisations",
      document_type: "finder",
      schema_name: "organisations_homepage",
      title: "Departments, agencies and public bodies",
      public_updated_at: "2021-04-01T11:09:50.000+00:00",
      description: "Information from government departments, agencies and public bodies, including news, campaigns, policies and contact details.",
      details: {
        ordered_ministerial_departments: Array.new(5, {}),
        ordered_agencies_and_other_public_bodies: Array.new(42, {}),
      },
    }

    stub_content_store_has_item("/government/organisations", @organisations_payload)
    stub_content_store_has_item("/", schema: "special_route")
  end

  should "render the homepage" do
    visit "/"
    assert_equal 200, page.status_code
    assert_equal "Welcome to GOV.UK", page.title
  end

  should "show a count of ministerial departments from the organisations API" do
    visit "/"
    within ".home-numbers > li:nth-child(1)" do
      assert_equal "5 Ministerial departments", page.find("a.home-numbers__link").text
    end
  end

  should "show a count of other agencies and public bodies from the organisations API" do
    visit "/"
    within ".home-numbers > li:nth-child(2)" do
      assert_equal "42 Other agencies and public bodies", page.find("a.home-numbers__link").text
    end
  end

  should "not count ministerial departments who have a govuk_status joining" do
    orgs_with_joining = @organisations_payload
    orgs_with_joining[:details][:ordered_ministerial_departments] = Array.new(10, {}) << { "govuk_status": "joining" }
    stub_content_store_has_item("/government/organisations", orgs_with_joining)

    visit "/"
    within ".home-numbers > li:nth-child(1)" do
      assert_equal "10 Ministerial departments", page.find("a.home-numbers__link").text
    end
  end

  should "not count other agencies and public bodies who have a govuk_status joining" do
    orgs_with_joining = @organisations_payload
    orgs_with_joining[:details][:ordered_agencies_and_other_public_bodies] = Array.new(20, {}) << { "govuk_status": "joining" }
    stub_content_store_has_item("/government/organisations", orgs_with_joining)

    visit "/"
    within ".home-numbers > li:nth-child(2)" do
      assert_equal "20 Other agencies and public bodies", page.find("a.home-numbers__link").text
    end
  end
end
