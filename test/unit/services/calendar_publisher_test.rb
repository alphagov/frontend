require "test_helper"
require "govuk-content-schema-test-helpers/test_unit"

class CalendarPublisherTest < ActiveSupport::TestCase
  include GovukContentSchemaTestHelpers::TestUnit

  def test_publishing_to_publishing_api
    GovukContentSchemaTestHelpers.configure do |config|
      config.schema_type = "publisher_v2"
      config.project_root = Rails.root
    end

    Services.publishing_api.expects(:put_content).with(
      "58f79dbd-e57f-4ab2-ae96-96df5767d1b2", valid_payload_for("calendar")
    )
    Services.publishing_api.expects(:publish).with("58f79dbd-e57f-4ab2-ae96-96df5767d1b2", nil, { locale: :en })
    Services.publishing_api.expects(:patch_links).with(
      "58f79dbd-e57f-4ab2-ae96-96df5767d1b2",
      links: { primary_publishing_organisation: %w[af07d5a5-df63-4ddc-9383-6a666845ebe9] },
    )

    calendar = Calendar.find("bank-holidays")

    CalendarPublisher.new(calendar).publish
  end
end
