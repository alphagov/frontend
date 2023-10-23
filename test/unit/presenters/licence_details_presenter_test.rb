require "test_helper"

class LicenceDetailsPresenterTest < ActiveSupport::TestCase
  setup do
    @local_authority_licence = {
      "isLocationSpecific" => true,
      "isOfferedByCounty" => false,
      "geographicalAvailability" => %w[England Wales],
      "issuingAuthorities" => [
        {
          "authorityName" => "Westminster City Council",
          "authoritySlug" => "westminster",
          "authorityContact" => {
            "website" => "",
            "email" => "",
            "phone" => "020 7641 6000",
            "address" => "P.O. Box 240\nWestminster City Hall\n\n\nSW1E 6QP",
          },
          "authorityInteractions" => {
            "apply" => [
              {
                "url" => "westminster/apply-1",
                "description" => "Temporary Event Notice",
                "payment" => "fixed",
                "paymentAmount" => "21.00",
                "introductionText" => "Intro text",
                "usesLicensify" => true,
                "usesAuthorityUrl" => true,
              },
            ],
          },
        },
      ],
    }

    @the_one_licence_authority = {
      "authorityName" => "The One Licence Authority",
      "authoritySlug" => "the-one-licence-authority",
      "authorityInteractions" => {
        "apply" => [
          {
            "url" => "the-one-licence-authority/apply-1",
            "usesLicensify" => true,
            "usesAuthorityUrl" => true,
          },
        ],
      },
    }

    @the_other_licence_authority = {
      "authorityName" => "The Other Licence Authority",
      "authoritySlug" => "the-other-licence-authority",
      "authorityInteractions" => {
        "apply" => [
          {
            "url" => "the-other-licence-authority/apply-1",
            "usesLicensify" => true,
            "usesAuthorityUrl" => true,
          },
        ],
      },
    }

    @licence_authority_not_using_licensify = {
      "authorityName" => "The Licence Authority Not Using Licensify",
      "authoritySlug" => "the-licence-authority-not-using-licensify",
      "authorityInteractions" => {
        "apply" => [
          {
            "url" => "the-licence-authority-not-using-licensify/apply-1",
            "usesLicensify" => "false",
            "usesAuthorityUrl" => "true",
          },
        ],
      },
    }

    @licence_authority_not_using_authority_url = {
      "authorityName" => "The Licence Authority Not Using Licensify",
      "authoritySlug" => "the-licence-authority-not-using-licensify",
      "authorityInteractions" => {
        "apply" => [
          {
            "url" => "the-licence-authority-not-using-licensify/apply-1",
            "usesLicensify" => "true",
            "usesAuthorityUrl" => "false",
          },
        ],
      },
    }

    @licence_authority_without_uses_licensify_param = {
      "authorityName" => "The Licence Authority Without UsesLicensify Param",
      "authoritySlug" => "the-licence-authority-without-uses-licensify-param",
      "authorityInteractions" => {
        "apply" => [
          {
            "url" => "the-licence-authority-without-uses-licensify-param/apply-1",
            "usesAuthorityUrl" => "true",
          },
        ],
      },
    }

    @licence_authority_without_uses_authority_url_param = {
      "authorityName" => "The Licence Authority Without UsesLicensify Param",
      "authoritySlug" => "the-licence-authority-without-uses-licensify-param",
      "authorityInteractions" => {
        "apply" => [
          {
            "url" => "the-licence-authority-without-uses-licensify-param/apply-1",
            "usesLicensify" => "true",
          },
        ],
      },
    }

    @licence_authority_with_no_actions = {
      "authorityName" => "The Licence Authority with no actions",
      "authoritySlug" => "the-licence-authority-with-no-actions",
      "authorityInteractions" => {},
    }

    @licence_authority_licence = {
      "isLocationSpecific" => false,
      "isOfferedByCounty" => false,
      "geographicalAvailability" => %w[England Wales],
      "issuingAuthorities" => [
        @the_one_licence_authority,
      ],
    }

    @multiple_authorities_and_location_specific_licence = {
      "isLocationSpecific" => true,
      "isOfferedByCounty" => false,
      "geographicalAvailability" => %w[England Wales],
      "issuingAuthorities" => [
        @the_other_licence_authority,
        @the_one_licence_authority,
      ],
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

        assert_not subject.single_licence_authority_present?
      end
    end

    context "when authority non-present" do
      should "return false" do
        subject = LicenceDetailsPresenter.new(@licence_authority_licence.merge("issuingAuthorities" => []))

        assert_not subject.single_licence_authority_present?
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
              "payment" => nil,
              "uses_licensify" => true,
              "uses_authority_url" => true,
            },
          ],
        },
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
              "payment" => nil,
              "uses_licensify" => true,
              "uses_authority_url" => true,
            },
          ],
        },
      }
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
          subject = LicenceDetailsPresenter.new(@multiple_authorities_and_location_specific_licence, "the-other-licence-authority")

          assert_equal @presented_the_other_licence_authority, subject.authority
        end

        should "return nil if no matched authority found" do
          subject = LicenceDetailsPresenter.new(@multiple_authorities_and_location_specific_licence, "a-funky-licence-authority")

          assert_nil subject.authority
        end

        context "no authority_slug is provided" do
          should "return the first authority" do
            subject = LicenceDetailsPresenter.new(@multiple_authorities_and_location_specific_licence)

            assert_equal @presented_the_other_licence_authority, subject.authority
          end
        end
      end

      context "when no authority is present" do
        should "return nil" do
          subject = LicenceDetailsPresenter.new(@licence_authority_licence.merge("issuingAuthorities" => []))

          assert_nil subject.authority
        end
      end
    end
  end

  context "#uses_licensify" do
    should "return true if the action has a field to confirm that it uses licensify" do
      subject = LicenceDetailsPresenter.new(@licence_authority_licence, "the-one-licence-authority")

      assert_equal subject.uses_licensify("apply"), true
    end

    should "return true if the default action has uses_licensify set to true" do
      subject = LicenceDetailsPresenter.new(@licence_authority_licence, "the-one-licence-authority", "apply")

      assert_equal subject.uses_licensify, true
    end

    should "return false if the action has the uses_licensify field set to false" do
      subject = LicenceDetailsPresenter.new(@licence_authority_not_using_licensify)

      assert_equal subject.uses_licensify("apply"), false
    end

    should "return false if the action does not have a usesLicensify field" do
      subject = LicenceDetailsPresenter.new(@licence_authority_without_uses_licensify_param)

      assert_equal subject.uses_licensify("apply"), false
    end

    should "return false if authority is nil" do
      subject = LicenceDetailsPresenter.new(@the_one_licence_authority)

      assert_equal subject.uses_licensify("apply"), false
    end
  end

  context "#uses_authority_url" do
    should "return true if the action has a field to confirm that it uses authority url" do
      subject = LicenceDetailsPresenter.new(@licence_authority_licence, "the-one-licence-authority")

      assert_equal subject.uses_authority_url("apply"), true
    end

    should "return true if the default action has uses_authority_url set to true" do
      subject = LicenceDetailsPresenter.new(@licence_authority_licence, "the-one-licence-authority", "apply")

      assert_equal subject.uses_authority_url, true
    end

    should "return false if the action has the uses_authority_url field set to false" do
      subject = LicenceDetailsPresenter.new(@licence_authority_not_using_authority_url)

      assert_equal subject.uses_authority_url("apply"), false
    end

    should "return false if the action does not have a usesAuthorityUrl field" do
      subject = LicenceDetailsPresenter.new(@licence_authority_without_uses_authority_url_param)

      assert_equal subject.uses_authority_url("apply"), false
    end

    should "return false if authority is nil" do
      subject = LicenceDetailsPresenter.new(@the_one_licence_authority)

      assert_equal subject.uses_authority_url("apply"), false
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
