require "test_helper"

class LocalTransactionPresenterTest < ActiveSupport::TestCase
  def subject(content_item)
    LocalTransactionPresenter.new(content_item.deep_stringify_keys!)
  end

  test "#introduction" do
    assert_equal "foo", subject(details: { introduction: "foo" }).introduction
  end

  test "#more_information" do
    assert_equal "foo", subject(details: { more_information: "foo" }).more_information
  end

  test "#need_to_know" do
    assert_equal "foo", subject(details: { need_to_know: "foo" }).need_to_know
  end

  test "#scotland_availability" do
    devolved_administration = { "details" => { "scotland_availability" => { "type" => "devolved_administration_service", "alternative_url" => "https://gov.scot" } } }

    assert_equal "devolved_administration_service", subject(devolved_administration).scotland_availability["type"]
    assert_equal "https://gov.scot", subject(devolved_administration).scotland_availability["alternative_url"]
  end

  test "#wales_availability" do
    devolved_administration = { "details" => { "wales_availability" => { "type" => "unavailable" } } }

    assert_equal "unavailable", subject(devolved_administration).wales_availability["type"]
    assert_equal nil, subject(devolved_administration).wales_availability["alternative_url"]
  end

  test "#northern_ireland_availability" do
    devolved_administration = { "details" => { "northern_ireland_availability" => { "type" => "devolved_administration_service", "alternative_url" => "https://www.nidirect.gov.uk" } } }

    assert_equal "devolved_administration_service", subject(devolved_administration).northern_ireland_availability["type"]
    assert_equal "https://www.nidirect.gov.uk", subject(devolved_administration).northern_ireland_availability["alternative_url"]
  end

  test "#unavailable? returns true for a devolved administration marked as unavailable" do
    devolved_administration = { "details" => { "wales_availability" => { "type" => "unavailable" } } }

    assert_equal true, subject(devolved_administration).unavailable?("Wales")
  end

  test "#unavailable? returns false for a devolved administration marked as devolved_administration_service" do
    devolved_administration = { "details" => { "scotland_availability" => { "type" => "devolved_administration_service", "alternative_url" => "https://gov.scot" } } }

    assert_equal false, subject(devolved_administration).unavailable?("Scotland")
  end

  test "#unavailable? returns false for a non devolved administration" do
    devolved_administration = { "details" => {} }

    assert_equal false, subject(devolved_administration).unavailable?("England")
  end

  test "#devolved_administration_service? returns true for a devolved administration marked as devolved_administration_service" do
    devolved_administration = { "details" => { "scotland_availability" => { "type" => "devolved_administration_service", "alternative_url" => "https://gov.scot" } } }
    assert_equal true, subject(devolved_administration).devolved_administration_service?("Scotland")
  end

  test "#devolved_administration_service? returns false for a devolved administration marked as unavailable" do
    devolved_administration = { "details" => { "wales_availability" => { "type" => "unavailable" } } }
    assert_equal false, subject(devolved_administration).devolved_administration_service?("Wales")
  end

  test "#devolved_administration_service? returns false for a non devolved administration" do
    devolved_administration = { "details" => {} }

    assert_equal false, subject(devolved_administration).devolved_administration_service?("England")
  end

  test "#devolved_administration_service_alternative_url returns an alternative_url for a devolved_administration_service" do
    devolved_administration = { "details" => { "scotland_availability" => { "type" => "devolved_administration_service", "alternative_url" => "https://gov.scot" } } }
    assert_equal "https://gov.scot", subject(devolved_administration).devolved_administration_service_alternative_url("Scotland")
  end

  test "#devolved_administration_service_alternative_url does not return an alternative_url for an unavailable service" do
    devolved_administration = { "details" => { "wales_availability" => { "type" => "unavailable" } } }
    assert_equal nil, subject(devolved_administration).devolved_administration_service_alternative_url("Wales")
  end

  test "#devolved_administration_service_alternative_url does not return an alternative_url for a non devolved administration" do
    devolved_administration = { "details" => {} }
    assert_equal nil, subject(devolved_administration).devolved_administration_service_alternative_url("England")
  end
end
