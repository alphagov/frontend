require 'test_helper'

class LocalAuthorityPresenterTest < ActiveSupport::TestCase
  context 'exposing attributes from the json payload' do
    setup do
      @local_authority_payload = {
        "name" => "Westminster City Council",
        "snac" => "00BK",
        "tier" => "district",
        "contact_address" => [
          "123 Example Street",
          "SW1A 1AA"
        ],
        "contact_url" => "http://westminster.example.com/contact-us",
        "contact_phone" => "020 1234 567",
        "contact_email" => "info@westminster.gov.uk",
        "homepage_url" => 'http://westminster.example.com/',
      }
      @local_authority_presenter = LocalAuthorityPresenter.new(@local_authority_payload)
    end
    [
      :name, :snac, :tier, :contact_address, :contact_url,
      :contact_phone, :contact_email, :homepage_url,
    ].each do |exposed_attribute|
      should "expose value of #{exposed_attribute} from payload via a method" do
        assert @local_authority_presenter.respond_to? exposed_attribute
        assert_equal @local_authority_payload[exposed_attribute.to_s], @local_authority_presenter.send(exposed_attribute)
      end
    end
  end

  context '#url' do
    context 'when homepage_url is present' do
      setup do
        @local_authority_payload = {
          "name" => "Westminster City Council",
          "contact_url" => "http://westminster.example.com/contact-us",
          "homepage_url" => 'http://westminster.example.com/',
        }
        @local_authority_presenter = LocalAuthorityPresenter.new(@local_authority_payload)
      end

      should 'expose the homepage_url as the url' do
        assert_equal 'http://westminster.example.com/', @local_authority_presenter.url
      end
    end

    context 'when homepage_url is blank' do
      context 'and contact_url is present' do
        setup do
          @local_authority_payload = {
            "name" => "Westminster City Council",
            "contact_url" => "http://westminster.example.com/contact-us",
            "homepage_url" => '',
          }
          @local_authority_presenter = LocalAuthorityPresenter.new(@local_authority_payload)
        end

        should 'expose the contact_url as the url' do
          assert_equal 'http://westminster.example.com/contact-us', @local_authority_presenter.url
        end
      end

      context 'and contact_url is blank' do
        setup do
          @local_authority_payload = {
            "name" => "Westminster City Council",
            "contact_url" => '',
            "homepage_url" => '',
          }
          @local_authority_presenter = LocalAuthorityPresenter.new(@local_authority_payload)
        end

        should 'exposes no url' do
          assert_equal nil, @local_authority_presenter.url
        end
      end
    end

    context 'when homepage_url is not in the payload' do
      context 'and contact_url is present' do
        setup do
          @local_authority_payload = {
            "name" => "Westminster City Council",
            "contact_url" => "http://westminster.example.com/contact-us",
          }
          @local_authority_presenter = LocalAuthorityPresenter.new(@local_authority_payload)
        end

        should 'expose the contact_url as the url' do
          assert_equal 'http://westminster.example.com/contact-us', @local_authority_presenter.url
        end
      end

      context 'and contact_url is blank' do
        setup do
          @local_authority_payload = {
            "name" => "Westminster City Council",
            "contact_url" => '',
          }
          @local_authority_presenter = LocalAuthorityPresenter.new(@local_authority_payload)
        end

        should 'exposes no url' do
          assert_equal nil, @local_authority_presenter.url
        end
      end

      context 'and contact_url is not in the payload' do
        setup do
          @local_authority_payload = {
            "name" => "Westminster City Council",
          }
          @local_authority_presenter = LocalAuthorityPresenter.new(@local_authority_payload)
        end

        should 'exposes no url' do
          assert_equal nil, @local_authority_presenter.url
        end
      end
    end
  end
end
