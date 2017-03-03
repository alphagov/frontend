require "test_helper"

class LicencePresenterTest < ActiveSupport::TestCase
  setup do
    licence = {
      "id" => "https://www.gov.uk/api/temporary-events-notice.json",
      "content_id" => "cb16a948-d4c9-4e55-99b9-2f3931481b07",
      "web_url" => "https://www.gov.uk/temporary-events-notice",
      "title" => "Temporary Events Notice (England and Wales)",
      "format" => "licence",
      "owning_app" => "publisher",
      "in_beta" => false,
      "updated_at" => "2016-11-23T16:48:53:00:00",
      "details" => {
        "need_ids" => [
          "102218"
        ],
        "description" => "Description of a Temporary Events Notice.",
        "language" => "en",
        "continuation_link" => "",
        "licence_identifier" => "1071-5-1",
        "licence_overview" => "This is an unimaginative overview.",
        "licence_short_description" => "An equally unimaginative short description.",
        "will_continue_on" => "",
      },
    }

    @subject = LicencePresenter.new(licence)
  end

  should "extract the slug from the URL path" do
    assert_equal "temporary-events-notice", @subject.slug
  end

  should "show the updated_at date in the correct time zone" do
    assert_equal "Wed, 23 Nov 2016 16:48:53 UTC +00:00".to_datetime, @subject.updated_at
  end

  should "show the correct locale for the licence" do
    assert_equal "en", @subject.locale
  end
end
