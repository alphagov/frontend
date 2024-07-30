RSpec.describe "Calendars" do
  include ContentStoreHelpers

  before do
    stub_content_store_has_item("/something", schema_name: "calendar")
  end

  it "returns 404 for a non-existent calendar" do
    allow(Calendar).to receive(:find).and_raise(Calendar::CalendarNotFound)
    get "/something"

    expect(get("/something")).to route_to(controller: "calendar", action: "show_calendar", scope: "something")
  end

  it "does not route an invalid slug format, and does not try to look up the calendar" do
    expect(Calendar).not_to receive(:find)
    expect(get("/something..etc-passwd")).not_to route_to(controller: "calendar")
  end
end
