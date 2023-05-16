require "test_helper"

class LocalAuthorityPresenterTest < ActiveSupport::TestCase
  context "exposing attributes from the json payload" do
    setup do
      @local_authority_payload = {
        "name" => "Westminster City Council",
        "snac" => "00BK",
        "gss" => "E060000034",
        "tier" => "district",
        "homepage_url" => "http://westminster.example.com/",
      }
      @local_authority_presenter = LocalAuthorityPresenter.new(@local_authority_payload)
    end
    %i[
      name snac gss tier homepage_url
    ].each do |exposed_attribute|
      should "expose value of #{exposed_attribute} from payload via a method" do
        assert @local_authority_presenter.respond_to? exposed_attribute
        assert_equal @local_authority_payload[exposed_attribute.to_s], @local_authority_presenter.send(exposed_attribute)
      end
    end
  end

  context "#url" do
    context "when homepage_url is present" do
      setup do
        @local_authority_payload = {
          "name" => "Westminster City Council",
          "homepage_url" => "http://westminster.example.com/",
        }
        @local_authority_presenter = LocalAuthorityPresenter.new(@local_authority_payload)
      end

      should "expose the homepage_url as the url" do
        assert_equal "http://westminster.example.com/", @local_authority_presenter.url
      end
    end

    context "when homepage_url is blank" do
      setup do
        @local_authority_payload = {
          "name" => "Westminster City Council",
          "homepage_url" => "",
        }
        @local_authority_presenter = LocalAuthorityPresenter.new(@local_authority_payload)
      end

      should "exposes no url" do
        assert_nil @local_authority_presenter.url
      end
    end
  end
end
