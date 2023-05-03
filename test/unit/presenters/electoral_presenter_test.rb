require "test_helper"

class ElectoralPresenterTest < ActiveSupport::TestCase
  def api_response
    path = Rails.root.join("test/fixtures/electoral-result.json")
    fixture = File.read(path)
    JSON.parse(fixture)
  end

  def electoral_presenter(payload)
    ElectoralPresenter.new(payload)
  end

  context "exposing attributes from the json payload" do
    ElectoralPresenter::EXPECTED_KEYS.each do |exposed_attribute|
      should "expose value of #{exposed_attribute} from payload via a method" do
        subject = electoral_presenter(api_response)
        assert subject.respond_to? exposed_attribute
        assert_equal api_response[exposed_attribute], subject.send(exposed_attribute)
      end
    end
  end

  context "when dates and ballots are present in the api response" do
    should "should present upcoming elections" do
      subject = electoral_presenter(api_response)
      expected = ["2017-05-04 - Cardiff local election Pontprennau/Old St. Mellons"]
      assert_equal subject.upcoming_elections, expected
    end
  end

  context "presenting addresses" do
    context "when duplicate contact details are provided" do
      should "we should not show the electoral services address" do
        with_duplicate_contact = api_response
        with_duplicate_contact["registration"] = { "address" => "foo bar" }
        with_duplicate_contact["electoral_services"] = { "address" => " foo  bar " }
        subject = electoral_presenter(with_duplicate_contact)
        assert_equal subject.use_electoral_services_contact_details?, false
      end
    end

    context "when both contact details are different" do
      should "we should show both addresses" do
        with_different_contact = api_response
        with_different_contact["registration"] = { "address" => "foo bar" }
        with_different_contact["electoral_services"] = { "address" => " baz boo " }
        subject = electoral_presenter(with_different_contact)
        assert_equal subject.use_electoral_services_contact_details?, true
        assert_equal subject.use_registration_contact_details?, true
      end
    end

    context "when address picker is present in the api response" do
      setup do
        @with_address_picker = api_response
        @with_address_picker["address_picker"] = true
      end

      context "address details are present" do
        should "#show_picker? returns true" do
          with_no_contact_details = @with_address_picker
          with_no_contact_details["registration"] = nil
          with_no_contact_details["electoral_services"] = nil
          subject = electoral_presenter(with_no_contact_details)
          assert_equal subject.show_picker?, true
        end
      end

      context "address details are missing" do
        should "#show_picker? returns false" do
          subject = electoral_presenter(@with_address_picker)
          assert_equal subject.show_picker?, false
        end
      end
    end
  end
end
