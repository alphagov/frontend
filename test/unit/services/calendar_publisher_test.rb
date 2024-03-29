require "test_helper"

class CalendarPublisherTest < ActiveSupport::TestCase
  def test_publishing_to_publishing_api
    publishing_api = Object.new
    publishing_api.expects(:put_content).with(
      "58f79dbd-e57f-4ab2-ae96-96df5767d1b2", valid_payload_for("calendar")
    )
    publishing_api.expects(:publish).with("58f79dbd-e57f-4ab2-ae96-96df5767d1b2", nil, { locale: :en })
    publishing_api.expects(:patch_links).with(
      "58f79dbd-e57f-4ab2-ae96-96df5767d1b2",
      { links: { primary_publishing_organisation: %w[af07d5a5-df63-4ddc-9383-6a666845ebe9] } },
    )
    GdsApi.expects(:publishing_api).at_least_once.returns(publishing_api)

    calendar = Calendar.find("bank-holidays")

    CalendarPublisher.new(calendar).publish
  end
end
