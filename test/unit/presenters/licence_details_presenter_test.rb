require "test_helper"

class LicenceDetailsPresenterTest < ActiveSupport::TestCase
  setup do
    @local_authority_licence = {
      "isLocationSpecific" => true,
      "isOfferedByCounty" => false,
      "geographicalAvailability" => %w(England Wales),
      "issuingAuthorities" => [
        {
          "authorityName" => "Westminster City Council",
          "authoritySlug" => "westminster",
          "authorityContact" => {
            "website" => "",
            "email" => "",
            "phone" => "020 7641 6000",
            "address" => "P.O. Box 240\nWestminster City Hall\n\n\nSW1E 6QP"
          },
          "authorityInteractions" => {
            "apply" => [
              {
                "url" => "westminster/apply-1",
                "usesLicensify" => true,
                "description" => "Temporary Event Notice",
                "payment" => "fixed",
                "paymentAmount" => "21.00",
                "introductionText" => "Intro text"
              }
            ]
          }
        }
      ]
    }

    @the_one_licence_authority = {
      "authorityName" => "The One Licence Authority",
      "authoritySlug" => "the-one-licence-authority",
      "authorityInteractions" => {
        "apply" => [
          {
            "url" => "the-one-licence-authority/apply-1",
          }
        ]
      }
    }

    @the_other_licence_authority = {
      "authorityName" => "The Other Licence Authority",
      "authoritySlug" => "the-other-licence-authority",
      "authorityInteractions" => {
        "apply" => [
          {
            "url" => "the-other-licence-authority/apply-1",
          }
        ]
      }
    }

    @licence_authority_licence = {
      "isLocationSpecific" => false,
      "isOfferedByCounty" => false,
      "geographicalAvailability" => %w(England Wales),
      "issuingAuthorities" => [
        @the_one_licence_authority
      ]
    }

    @licence_multiple_authorities_licence = {
      "isLocationSpecific" => false,
      "isOfferedByCounty" => false,
      "geographicalAvailability" => %w(England Wales),
      "issuingAuthorities" => [
        @the_one_licence_authority,
        @the_other_licence_authority,
      ]
    }
  end

  context "#single_licence_authority_present?" do
    context "when authority present" do
      should "return true for licence authority specific licence" do
        subject = LicenceDetailsPresenter.new(@licence_authority_licence)

        assert subject.single_licence_authority_present?
      end

      should "return false for local authority specific licence" do
        subject = LicenceDetailsPresenter.new(@local_authority_licence)

        refute subject.single_licence_authority_present?
      end
    end

    context "when authority non-present" do
      should "return false" do
        subject = LicenceDetailsPresenter.new(@licence_authority_licence.merge("issuingAuthorities" => []))

        refute subject.single_licence_authority_present?
      end
    end
  end

  context "#multiple_licence_authorities_present?" do
    context "when more than one authority present" do
      should "return true for licence authority specific licence" do
        subject = LicenceDetailsPresenter.new(@licence_multiple_authorities_licence)

        assert subject.multiple_licence_authorities_present?
      end

      should "return false for local authority specific licence" do
        subject = LicenceDetailsPresenter.new(@local_authority_licence)

        refute subject.single_licence_authority_present?
      end
    end

    context "when zero or one authority present" do
      should "return false" do
        subject = LicenceDetailsPresenter.new(@licence_multiple_authorities_licence.merge("issuingAuthorities" => []))

        refute subject.single_licence_authority_present?
      end
    end
  end

  context "authority look up methods" do
    setup do
      @presented_the_one_licence_authority = {
        "name" => "The One Licence Authority",
        "slug" => "the-one-licence-authority",
        "contact" => nil,
        "actions" => {
          "apply" => [
            {
              "url" => "the-one-licence-authority/apply-1",
              "introduction" => nil,
              "description" => nil,
              "payment" => nil
            }
          ]
        }
      }

      @presented_the_other_licence_authority = {
        "name" => "The Other Licence Authority",
        "slug" => "the-other-licence-authority",
        "contact" => nil,
        "actions" => {
          "apply" => [
            {
              "url" => "the-other-licence-authority/apply-1",
              "introduction" => nil,
              "description" => nil,
              "payment" => nil
            }
          ]
        }
      }
    end

    context "#authorities" do
      should "return a representative array of hashes" do
        subject = LicenceDetailsPresenter.new(@licence_multiple_authorities_licence)
        expected_array = [
          @presented_the_one_licence_authority,
          @presented_the_other_licence_authority
        ]

        assert_equal expected_array, subject.authorities
      end

      should "return an empty array if no authorities present" do
        subject = LicenceDetailsPresenter.new(@licence_multiple_authorities_licence.merge("issuingAuthorities" => []))

        assert_equal [], subject.authorities
      end
    end

    context "#authority" do
      context "when one authority is present" do
        should "return the authority" do
          subject = LicenceDetailsPresenter.new(@licence_authority_licence)

          assert_equal @presented_the_one_licence_authority, subject.authority
        end
      end

      context "when more than one authority are present" do
        should "return the matched authority if authority slug provided" do
          subject = LicenceDetailsPresenter.new(@licence_multiple_authorities_licence, "the-other-licence-authority")

          assert_equal @presented_the_other_licence_authority, subject.authority
        end

        should "return nil if no matched authority found" do
          subject = LicenceDetailsPresenter.new(@licence_multiple_authorities_licence, "a-funky-licence-authority")

          assert_nil subject.authority
        end
      end

      context "when no authority is present" do
        should "return nil" do
          subject = LicenceDetailsPresenter.new(@licence_multiple_authorities_licence.merge("issuingAuthorities" => []))

          assert_nil subject.authority
        end
      end
    end
  end

  context "#action" do
    should "return action name if available" do
      subject = LicenceDetailsPresenter.new(@local_authority_licence, nil, "apply")

      assert_equal "apply", subject.action
    end

    should "raise RecordNotFound if not available" do
      subject = LicenceDetailsPresenter.new(@local_authority_licence, nil, "complain")

      assert_raises RecordNotFound do
        subject.action
      end
    end
  end
end
