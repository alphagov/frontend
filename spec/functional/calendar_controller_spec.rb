RSpec.describe CalendarController, type: :controller do
  render_views

  context "GET 'calendar'" do
    before do
      allow(Calendar).to receive(:find).and_return(Calendar.new("something", "title" => "Brilliant holidays!", "divisions" => []))
      stub_content_store_has_item("/bank-holidays")
      stub_content_store_has_item("/when-do-the-clocks-change")
    end

    context "HTML request (no format)" do
      it "loads the calendar and show it" do
        get(:show_calendar, params: { scope: "bank-holidays" })

        expect(response.body).to(match("Brilliant holidays!"))
      end

      it "renders the template corresponding to the given calendar" do
        get(:show_calendar, params: { scope: "bank-holidays" })

        assert_template("bank_holidays")
      end

      it "sets the expiry headers" do
        get(:show_calendar, params: { scope: "bank-holidays" })

        honours_content_store_ttl
      end
    end

    context "for a welsh language content item" do
      it "sets the I18n locale" do
        content_item = content_item_for_base_path("/bank-holidays")
        content_item["locale"] = "cy"
        stub_content_store_has_item("/bank-holidays", content_item)
        get(:show_calendar, params: { scope: "gwyliau-banc", locale: "cy" })

        expect(I18n.locale).to eq(:cy)
      end
    end

    context "json request" do
      it "loads the calendar and return its json representation" do
        expect(Calendar).to receive(:find).with("bank-holidays").and_return(instance_double("Calendar", to_json: "json_calendar"))
        get(:show_calendar, params: { scope: "bank-holidays", format: :json })

        expect(response.body).to eq("json_calendar")
      end

      it "sets the expiry headers" do
        get(:show_calendar, params: { scope: "bank-holidays", format: :json })

        expect(response.headers["Cache-Control"]).to eq("max-age=3600, public")
      end

      it "sets the CORS headers" do
        get(:show_calendar, params: { scope: "bank-holidays", format: :json })

        expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
      end
    end

    it "returns 404 for a non-existent calendar" do
      stub_content_store_has_item("/something")
      allow(Calendar).to receive(:find).and_raise(Calendar::CalendarNotFound)
      get(:show_calendar, params: { scope: "something" })

      expect(response.status).to eq(404)
    end

    it "returns 404 without looking up the calendar with an invalid slug format" do
      expect(Calendar).not_to receive(:find)
      get(:show_calendar, params: { scope: "something..etc-passwd" })

      expect(response.status).to eq(404)
    end

    it "returns 403 if content store returns forbidden response" do
      stub_request(:get, "#{Plek.find('content-store')}/content/something-access-limited").to_return(status: 403, headers: {})
      get(:show_calendar, params: { scope: "something-access-limited" })

      expect(response.status).to eq(403)
    end
  end

  context "GET 'division'" do
    before do
      @division = instance_double("Division", to_json: "", events: [])
      @calendar = instance_double("Calendar", division: @division)
      allow(Calendar).to receive(:find).and_return(@calendar)
    end

    it "returns the json representation of the division" do
      expect(@division).to receive(:to_json).and_return("json_division")
      expect(@calendar).to receive(:division).with("a-division").and_return(@division)
      allow(Calendar).to receive(:find).with("a-calendar").and_return(@calendar)
      get(:division, params: { scope: "a-calendar", division: "a-division", format: "json" })

      expect(@response.body).to eq("json_division")
    end

    it "returns the ics representation of the division" do
      expect(@division).to receive(:events).and_return(:some_events)
      expect(@calendar).to receive(:division).with("a-division").and_return(@division)
      allow(Calendar).to receive(:find).with("a-calendar").and_return(@calendar)
      expect(IcsRenderer).to receive(:new).with(:some_events, "/a-calendar/a-division.ics").and_return(instance_double("Renderer", render: "ics_division"))
      get(:division, params: { scope: "a-calendar", division: "a-division", format: "ics" })

      expect(@response.body).to eq("ics_division")
    end

    it "sets the expiry headers" do
      get(:division, params: { scope: "a-calendar", division: "a-division", format: "ics" })

      expect(response.headers["Cache-Control"]).to eq("max-age=86400, public")
    end

    it "returns 404 for a html request" do
      get(:division, params: { scope: "a-calendar", division: "a-division", format: "html" })

      expect(@response.status).to eq(404)

      get(:division, params: { scope: "a-calendar", division: "a-division" })

      expect(@response.status).to eq(404)
    end

    it "returns 404 with an invalid division" do
      allow(@calendar).to receive(:division).and_raise(Calendar::CalendarNotFound)
      get(:division, params: { scope: "something", division: "foo", format: "json" })

      expect(response.status).to eq(404)
    end

    it "returns 404 for a non-existent calendar" do
      stub_content_store_has_item("/something")
      allow(Calendar).to receive(:find).and_raise(Calendar::CalendarNotFound)
      get(:division, params: { scope: "something", division: "foo", format: "json" })

      expect(response.status).to eq(404)
    end

    it "return 404 without looking up the calendar with an invalid slug format" do
      expect(Calendar).not_to receive(:find)
      get(:division, params: { scope: "something..etc-passwd", division: "foo", format: "json" })

      expect(response.status).to eq(404)
    end
  end
end
