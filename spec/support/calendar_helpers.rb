module CalendarHelpers
  def mock_calendar_fixtures
    stub_const("Calendar::REPOSITORY_PATH", "spec/fixtures")
  end
end
