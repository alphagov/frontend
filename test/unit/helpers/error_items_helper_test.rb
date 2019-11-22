require "test_helper"

class ErrorItemsHelperTest < ActionView::TestCase
  include ErrorItemsHelper

  setup do
    flash[:validation] = [
      { field: "full_name", text: "Enter full name" },
      { field: "job_title", text: "Enter job title" },
    ]
  end

  test "#error_items" do
    assert_equal "Enter job title", error_items("job_title")
    assert_nil error_items("email_address")
  end
end
