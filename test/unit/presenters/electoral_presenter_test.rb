require "test_helper"

class ElectoralPresenterTest < ActiveSupport::TestCase
  def api_response
    path = Rails.root.join("test/fixtures/electoral-result.json")
    fixture = File.read(path)
    JSON.parse(fixture)
  end

  def electoral_presenter(payload)
    @electoral_presenter ||= ElectoralPresenter.new(payload)
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
end
