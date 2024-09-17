RSpec.describe FaqPresenter do
  include CalendarHelpers

  before do
    @view_context = ApplicationController.new.view_context
    mock_calendar_fixtures
  end

  it "uses bank holiday body for bank holidays" do
    expected = [
      q_and_a("England and Wales", "The next bank holiday in England and Wales is Good Friday on the 6th of April"),
      q_and_a("Scotland", "The next bank holiday in Scotland is Good Friday on the 6th of April"),
      q_and_a("Northern Ireland", "The next bank holiday in Northern Ireland is Good Friday on the 6th of April"),
    ]
    Timecop.travel(Date.parse("2012-03-24")) do
      scope = "bank-holidays"
      calendar = Calendar.find(scope)
      presenter = described_class.new(scope, calendar, payload(calendar), @view_context)

      expect(presenter.metadata["mainEntity"]).to eq(expected)
    end
  end

  it "uses wdtcc body for wdtcc" do
    expected = [q_and_a("When do the clocks change?", "The clocks go forward on the 25th of March")]
    Timecop.travel(Date.parse("2012-03-24")) do
      scope = "when-do-the-clocks-change"
      calendar = Calendar.find(scope)
      presenter = described_class.new(scope, calendar, payload(calendar), @view_context)

      expect(presenter.metadata["mainEntity"]).to eq(expected)
    end
  end

private

  def q_and_a(question, answer)
    {
      "@type" => "Question",
      "name" => question,
      "acceptedAnswer" => { "@type" => "Answer", "text" => answer },
    }
  end

  def payload(calendar)
    {
      title: calendar.title,
      description: calendar.description,
    }
  end
end
