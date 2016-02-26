class ActionDispatch::IntegrationTest
  def assert_page_is_full_width
    assert_not page.has_css?(".grid-row")
  end
end
