require "integration_test_helper"

class CompletedTransactionTest < ActionDispatch::IntegrationTest
  setup do
    @payload = {
      base_path: "/done/no-promotion",
      schema_name: "completed_transaction",
      document_type: "completed_transaction",
      external_related_links: [],
    }
  end

  context "electric car test" do
    should "present the default variant" do
      payload = @payload.merge(details: {
        promotion: {
          url: "https://www.goultralow.com/ev-owners/benefits",
          category: "electric_vehicle",
        },
      })
      stub_content_store_has_item("/done/vehicle-tax", payload)
      visit "/done/vehicle-tax"

      assert_equal 200, page.status_code
      page.assert_text "Find out how much money you can save on fuel by switching to an electric vehicle."
      page.assert_text "Make your next car electric"
      page.assert_selector "a[href='https://www.goultralow.com/ev-owners/benefits']"
    end
  end

  context "a completed transaction edition" do
    should "show no promotion when there is no promotion choice" do
      payload = @payload.merge(title: "Give feedback on this service")
      stub_content_store_has_item("/done/no-promotion", payload)
      visit "/done/no-promotion"

      assert_equal 200, page.status_code

      assert_has_component_title "Give feedback on this service"

      within ".content-block" do
        assert page.has_no_selector?(".promotion")
      end
    end
  end

  context "legacy transaction finished pages' special cases" do
    should "not show the satisfaction survey for transaction-finished" do
      payload = @payload.merge(base_path: "/done/transaction-finished")

      stub_content_store_has_item("/done/transaction-finished", payload)

      visit "/done/transaction-finished"

      assert_not page.has_css?("h2.satisfaction-survey-heading")
      assert page.has_content?("Thanks for visiting GOV.UK.")
    end

    should "not show the satisfaction survey for driving-transaction-finished" do
      payload = @payload.merge(base_path: "/done/driving-transaction-finished")

      stub_content_store_has_item("/done/driving-transaction-finished", payload)

      visit "/done/driving-transaction-finished"

      assert_not page.has_css?("h2.satisfaction-survey-heading")
    end
  end

  context "satisfaction surveys" do
    context "for editions using the assisted digital survey" do
      setup do
        payload = @payload.merge(base_path: "/done/register-flood-risk-exemption")
        stub_content_store_has_item("/done/register-flood-risk-exemption", payload)
        visit "/done/register-flood-risk-exemption"
      end

      should "have a form that posts to the assisted-digital-survey endpoint" do
        assert page.has_text?("Help us improve this service")

        assert page.has_selector?("form[action='/contact/govuk/assisted-digital-survey-feedback']")

        within "form[action='/contact/govuk/assisted-digital-survey-feedback']" do
          within_fieldset "Did you receive any assistance to use this service today?" do
            assert page.has_field?("Yes", type: "radio")
            assert page.has_field?("No", type: "radio")
          end

          within_fieldset "Did you receive any assistance to use this service today?" do
            assert page.has_field?("What assistance did you receive?", type: "textarea")
          end

          within_fieldset "Who provided the assistance?" do
            assert page.has_field?("A friend or relative", type: "radio")
            assert page.has_field?("A work colleague", type: "radio")
            assert page.has_field?("A staff member of the responsible government department", type: "radio")
            assert page.has_field?("Other (please specify)", type: "radio")
            assert page.has_field?("Tell us who the other person was", type: "text")

            within "[data-module='govuk-radios'] > .govuk-radios__item:nth-child(3) + .govuk-radios__conditional" do
              within_fieldset "How satisfied are you with the assistance received?" do
                assert page.has_field?("Very satisfied", type: "radio")
                assert page.has_field?("Satisfied", type: "radio")
                assert page.has_field?("Neither satisfied or dissatisfied", type: "radio")
                assert page.has_field?("Dissatisfied", type: "radio")
                assert page.has_field?("Very dissatisfied", type: "radio")
              end
            end

            within "[data-module='govuk-radios'] > .govuk-radios__item:nth-child(5) + .govuk-radios__conditional" do
              within_fieldset "How satisfied are you with the assistance received?" do
                assert page.has_field?("Very satisfied", type: "radio")
                assert page.has_field?("Satisfied", type: "radio")
                assert page.has_field?("Neither satisfied or dissatisfied", type: "radio")
                assert page.has_field?("Dissatisfied", type: "radio")
                assert page.has_field?("Very dissatisfied", type: "radio")
              end
            end
          end

          within_fieldset "Who provided the assistance?" do
            assert page.has_field?("Is there any way the assistance received could be improved?", type: "textarea")
          end

          within_fieldset "Overall, how satisfied are you with the online service?" do
            assert page.has_field?("Very satisfied", type: "radio")
            assert page.has_field?("Satisfied", type: "radio")
            assert page.has_field?("Neither satisfied or dissatisfied", type: "radio")
            assert page.has_field?("Dissatisfied", type: "radio")
            assert page.has_field?("Very dissatisfied", type: "radio")
          end

          assert page.has_field?("Do you have any ideas for how this service could be improved?", type: "textarea")

          assert page.has_button?("Send feedback")
        end
      end
    end

    context "for editions using the normal satisfaction survey" do
      setup do
        payload = @payload.merge(base_path: "/done/register-to-vote")
        stub_content_store_has_item("/done/register-to-vote", payload)
        visit "/done/register-to-vote"
      end

      should "have a form that posts to the service-feedback endpoint" do
        assert page.has_text?("Satisfaction survey")

        assert page.has_selector?("form[action='/contact/govuk/service-feedback']")

        within "form[action='/contact/govuk/service-feedback']" do
          within_fieldset "Overall, how did you feel about the service you received today?" do
            assert page.has_field?("Very satisfied", type: "radio")
            assert page.has_field?("Satisfied", type: "radio")
            assert page.has_field?("Neither satisfied or dissatisfied", type: "radio")
            assert page.has_field?("Dissatisfied", type: "radio")
            assert page.has_field?("Very dissatisfied", type: "radio")
          end

          assert page.has_field?("How could we improve this service?", type: "textarea")

          assert page.has_button?("Send feedback")
        end
      end
    end

    context "promotions" do
      setup do
        payload = @payload.merge(
          base_path: "/done/check-mot-history",
          title: "Give feedback on Check the MOT history of a vehicle",
          details: {
            "promotion": {
              "category": "mot_reminder",
              "url": "https://www.gov.uk/mot-reminder",
            },
          },
        )

        stub_content_store_has_item("/done/check-mot-history", payload)
        visit "/done/check-mot-history"
      end

      should "show mot-reminder content if promotion choice has been selected" do
        assert_equal 200, page.status_code

        assert_has_component_title "Give feedback on Check the MOT history of a vehicle"

        within ".content-block" do
          assert page.has_selector?(".promotion")
          assert page.has_selector?("h2", text: "MOT promotion")
          assert page.has_content?("Get a text or email reminder when your MOT is due.")
        end
      end
    end
  end
end
