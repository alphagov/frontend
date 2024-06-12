RSpec.describe Calendar::Year, type: :model do
  it "returns the year string for to_s" do
    expect(Calendar::Year.new("2012", :a_division, []).to_s).to eq("2012")
  end

  describe "#events" do
    before do
      @y = Calendar::Year.new("1234", :a_division, [{ "title" => "foo", "date" => "02/01/2012" }, { "title" => "bar", "date" => "27/08/2012" }])
    end

    it "builds an event for each event in the data" do
      foo = Calendar::Event.new("title" => "foo", "date" => Date.civil(2012, 1, 2))
      bar = Calendar::Event.new("title" => "bar", "date" => Date.civil(2012, 8, 27))

      expect(@y.events).to eq([foo, bar])
    end

    it "caches the constructed instances" do
      first = @y.events

      expect(Calendar::Event).not_to receive(:new)
      expect(@y.events).to eq(first)
    end
  end

  describe "#upcoming_event" do
    it "return nil with no events" do
      y = Calendar::Year.new("1234", :a_division, [])

      expect(y.upcoming_event).to(be_nil)
    end

    it "returns nil with no future events" do
      y = Calendar::Year.new("1234", :a_division, [{ "title" => "foo", "date" => "02/01/2012" }, { "title" => "bar", "date" => "27/08/2012" }])

      expect(y.upcoming_event).to(be_nil)
    end

    it "returns the first event that's in the future" do
      y = Calendar::Year.new("1234", :a_division, [{ "title" => "foo", "date" => "02/01/2012" }, { "title" => "bar", "date" => "27/08/2012" }, { "title" => "baz", "date" => "16/10/2012" }])
      Timecop.travel(Date.parse("2012-03-24")) do
        expect(y.upcoming_event.title).to eq("bar")
      end
    end

    it "counts an event today as a future event" do
      y = Calendar::Year.new("1234", :a_division, [{ "title" => "foo", "date" => "02/01/2012" }, { "title" => "bar", "date" => "27/08/2012" }, { "title" => "baz", "date" => "16/10/2012" }])
      Timecop.travel(Date.parse("2012-08-27")) do
        expect(y.upcoming_event.title).to eq("bar")
      end
    end

    it "caches the event" do
      y = Calendar::Year.new("1234", :a_division, [{ "title" => "foo", "date" => "02/01/2012" }, { "title" => "bar", "date" => "27/08/2012" }, { "title" => "baz", "date" => "16/10/2012" }])
      Timecop.travel(Date.parse("2012-03-24")) do
        y.upcoming_event

        expect(y).not_to receive(:events)

        expect(y.upcoming_event.title).to eq("bar")
      end
    end
  end

  describe "#upcoming_events" do
    before do
      @year = Calendar::Year.new("1234", :a_division, [{ "title" => "foo", "date" => "02/01/2012" }, { "title" => "bar", "date" => "27/08/2012" }, { "title" => "baz", "date" => "16/10/2012" }])
    end

    it "returns all future events including today" do
      Timecop.travel("2012-08-27") do
        expect(@year.upcoming_events.map(&:title)).to eq(%w[bar baz])
      end
    end

    it "caches the result" do
      @year.upcoming_events

      expect(@year).not_to receive(:events)

      @year.upcoming_events
    end
  end

  describe "#past_events" do
    before do
      @year = Calendar::Year.new("1234", :a_division, [{ "title" => "foo", "date" => "02/01/2012" }, { "title" => "bar", "date" => "27/08/2012" }, { "title" => "baz", "date" => "16/10/2012" }])
    end

    it "returns all past events excluding today" do
      Timecop.travel("2012-08-27") do
        expect(@year.past_events.map(&:title)).to eq(%w[foo])
      end
    end

    it "caches the result" do
      @year.past_events

      expect(@year).not_to receive(:events)

      @year.past_events
    end
  end
end
