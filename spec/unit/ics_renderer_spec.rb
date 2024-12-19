require "ics_renderer"

RSpec.describe IcsRenderer do
  subject(:ics_renderer) { described_class.new([], "/foo/ics", :en) }

  context "when generating complete ics file" do
    it "generates correct ics header and footer" do
      expected = "BEGIN:VCALENDAR\r\n"
      (expected << "VERSION:2.0\r\n")
      (expected << "METHOD:PUBLISH\r\n")
      (expected << "PRODID:-//uk.gov/GOVUK calendars//EN\r\n")
      (expected << "CALSCALE:GREGORIAN\r\n")
      (expected << "END:VCALENDAR\r\n")
      expect(ics_renderer.render).to eq(expected)
    end

    context "and renderer is for Welsh" do
      subject(:ics_renderer) { described_class.new([], "/foo/ics", :cy) }

      it "handles locale correctly" do
        expect(ics_renderer.render).to match("PRODID:-//uk.gov/GOVUK calendars//CY")
      end
    end

    it "generates an event for each given event" do
      ics_renderer = described_class.new(%i[e1 e2], "/foo/ics", :en)

      allow(ics_renderer).to receive(:render_event).with(:e1).and_return("Event1 ics\r\n")
      allow(ics_renderer).to receive(:render_event).with(:e2).and_return("Event2 ics\r\n")

      expected = "BEGIN:VCALENDAR\r\n"
      (expected << "VERSION:2.0\r\n")
      (expected << "METHOD:PUBLISH\r\n")
      (expected << "PRODID:-//uk.gov/GOVUK calendars//EN\r\n")
      (expected << "CALSCALE:GREGORIAN\r\n")
      (expected << "Event1 ics\r\n")
      (expected << "Event2 ics\r\n")
      (expected << "END:VCALENDAR\r\n")
      expect(ics_renderer.render).to eq(expected)
    end
  end

  context "when generating an event" do
    before do
      allow(ics_renderer).to receive(:dtstamp).and_return("20121017T0100Z") # rubocop:disable RSpec/SubjectStub
    end

    it "generates an event" do
      e = Calendar::Event.new("title" => "bank_holidays.good_friday", "date" => "2012-04-14")

      expect(Digest::MD5).to receive(:hexdigest).with("/foo/ics").once.and_return("hash")
      expected = "BEGIN:VEVENT\r\n"
      (expected << "DTEND;VALUE=DATE:20120415\r\n")
      (expected << "DTSTART;VALUE=DATE:20120414\r\n")
      (expected << "SUMMARY:Good Friday\r\n")
      (expected << "UID:hash-2012-04-14-GoodFriday@gov.uk\r\n")
      (expected << "SEQUENCE:0\r\n")
      (expected << "DTSTAMP:20121017T0100Z\r\n")
      (expected << "END:VEVENT\r\n")
      expect(ics_renderer.render_event(e)).to eq(expected)
    end
  end

  describe "#uid" do
    subject(:ics_renderer) { described_class.new([], path, :en) }

    let(:path) { "/foo/bar.ics" }
    let(:hash) { Digest::MD5.hexdigest(path) }

    let(:first_event) { Calendar::Event.new("title" => "bank_holidays.new_year", "date" => Date.new(1982, 5, 28)) }
    let(:second_event) { Calendar::Event.new("title" => "bank_holidays.good_friday", "date" => Date.new(1984, 1, 16)) }

    it "uses calendar path, event title and event date to create a uid" do
      expect(ics_renderer.uid(first_event)).to eq("#{hash}-1982-05-28-NewYearsDay@gov.uk")
    end

    it "caches the hash generation" do
      expect(Digest::MD5).to receive(:hexdigest).with(path).once.and_return(hash)

      ics_renderer.uid(first_event)

      expect(ics_renderer.uid(second_event)).to eq("#{hash}-1984-01-16-GoodFriday@gov.uk")
    end
  end

  describe "#dstamp" do
    it "returns the mtime of the REVISION file" do
      allow(File).to receive(:mtime).with(Rails.root.join("REVISION")).and_return(Time.zone.parse("2012-04-06 14:53:54Z"))

      expect(ics_renderer.dtstamp).to eq("20120406T145354Z")
    end

    it "returns now if the file doesn't exist" do
      Timecop.freeze(Time.zone.parse("2012-11-27 16:13:27")) do
        allow(File).to receive(:mtime).with(Rails.root.join("REVISION")).and_raise(Errno::ENOENT)

        expect(ics_renderer.dtstamp).to eq("20121127T161327Z")
      end
    end

    it "caches the result" do
      expect(File).to receive(:mtime).with(Rails.root.join("REVISION")).once.and_return(Time.zone.parse("2012-04-06 14:53:54Z"))
      ics_renderer.dtstamp
      expect(ics_renderer.dtstamp).to eq("20120406T145354Z")
    end
  end
end
