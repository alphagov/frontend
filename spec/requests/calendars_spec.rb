RSpec.describe "Calendars" do
  context "GET 'calendar'" do
    before do
      allow(Calendar).to receive(:find).and_return(Calendar.new("bank-holidays", "title" => "Brilliant holidays!", "divisions" => []))
      stub_content_store_has_item("/bank-holidays", {
        schema_name: "calendar",
        title: "Brilliant holidays!",
        base_path: "/bank-holidays",
        details: {},
      })
      stub_content_store_has_item("/when-do-the-clocks-change", schema_name: "calendar")
    end

    context "HTML request (no format)" do
      it "loads the calendar and show it" do
        get "/bank-holidays"

        expect(response.body).to match("Brilliant holidays!")
      end

      it "renders the template corresponding to the given calendar" do
        get "/bank-holidays"

        expect(response).to render_template(:bank_holidays)
      end

      it "sets the expiry headers" do
        get "/bank-holidays"

        honours_content_store_ttl
      end
    end

    context "for a welsh language content item" do
      it "sets the I18n locale" do
        stub_content_store_has_item("/gwyliau-banc", {
          schema_name: "calendar",
          title: "Brilliant holidays!",
          base_path: "/gwyliau-banc",
          locale: :cy,
          details: {},
        })
        get "/gwyliau-banc", params: { locale: "cy" }

        expect(I18n.locale).to eq(:cy)
      end
    end

    context "json request" do
      it "loads the calendar and return its json representation" do
        expect(Calendar).to receive(:find).with("bank-holidays").and_return(instance_double("Calendar", to_json: "json_calendar"))
        get "/bank-holidays.json"

        expect(response.body).to eq("json_calendar")
      end

      it "sets the expiry headers" do
        get "/bank-holidays.json"

        expect(response.headers["Cache-Control"]).to eq("max-age=3600, public")
      end

      it "sets the CORS headers" do
        get "/bank-holidays.json"

        expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
      end
    end

    it "returns 404 for a non-existent calendar" do
      stub_content_store_has_item("/something", schema_name: "calendar")
      allow(Calendar).to receive(:find).and_raise(Calendar::CalendarNotFound)
      get "/something"

      expect(response).to have_http_status(:not_found)
    end

    it "returns 403 if content store returns forbidden response" do
      stub_request(:get, "#{Plek.find('content-store')}/content/something-access-limited").to_return(status: 403, headers: {})
      get "/something-access-limited"

      expect(response).to have_http_status(:forbidden)
    end
  end

  context "GET 'division'" do
    before do
      @division = instance_double("Division", to_json: "", events: [])
      @calendar = instance_double("Calendar", division: @division)
      allow(Calendar).to receive(:find).and_return(@calendar)
      stub_content_store_has_item("/a-calendar", {
        schema_name: "calendar",
        title: "A calendar with divisions",
        base_path: "/a-calendar",
        details: {},
      })
    end

    it "returns the json representation of the division" do
      expect(@division).to receive(:to_json).and_return("json_division")
      expect(@calendar).to receive(:division).with("a-division").and_return(@division)
      allow(Calendar).to receive(:find).with("a-calendar").and_return(@calendar)
      get "/a-calendar/a-division.json"

      expect(response.body).to eq("json_division")
    end

    it "returns the ics representation of the division" do
      expect(@division).to receive(:events).and_return(:some_events)
      expect(@calendar).to receive(:division).with("a-division").and_return(@division)
      allow(Calendar).to receive(:find).with("a-calendar").and_return(@calendar)
      expect(IcsRenderer).to receive(:new).with(:some_events, "/a-calendar/a-division.ics", :en).and_return(instance_double("Renderer", render: "ics_division"))
      get "/a-calendar/a-division.ics"

      expect(response.body).to eq("ics_division")
    end

    it "sets the expiry headers" do
      get "/a-calendar/a-division.ics"

      expect(response.headers["Cache-Control"]).to eq("max-age=86400, public")
    end

    it "returns 404 for a html request" do
      get "/a-calendar/a-division.html"

      expect(response).to have_http_status(:not_found)

      get "/a-calendar/a-division"

      expect(response).to have_http_status(:not_found)
    end

    it "returns 404 with an invalid division" do
      allow(@calendar).to receive(:division).and_raise(Calendar::CalendarNotFound)
      get "/a-calendar/foo.json"

      expect(response).to have_http_status(:not_found)
    end

    it "returns 404 for a non-existent calendar" do
      stub_content_store_has_item("/something", schema_name: "calendar")
      allow(Calendar).to receive(:find).and_raise(Calendar::CalendarNotFound)
      get "/something/foo.json"

      expect(response).to have_http_status(:not_found)
    end

    it "does not route an invalid slug format, and does not try to look up the calendar" do
      expect(Calendar).not_to receive(:find)
      expect { get "/something..etc-passwd/foo.json" }.to raise_error(ActionController::RoutingError)
    end
  end
end
