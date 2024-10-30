class FaqPresenter
  def initialize(scope, calendar, content_item, view_context)
    @scope = scope
    @calendar = calendar
    @content_item = content_item.symbolize_keys
    @view_context = view_context
  end

  def metadata
    # http://schema.org/FAQPage
    {
      "@context" => "http://schema.org",
      "@type" => "FAQPage",
      "headline" => content_item[:title],
      "description" => content_item[:description],
      "publisher" => {
        "@type" => "Organization",
        "name" => "GOV.UK",
        "url" => "https://www.gov.uk",
        "logo" => {
          "@type" => "ImageObject",
          "url" => logo_url,
        },
      },
      "mainEntity" => questions_and_answers,
    }
  end

private

  attr_reader :scope, :calendar, :content_item, :view_context

  def questions_and_answers
    calendar.divisions.map { |division| answer_for(division) }.compact
  end

  def answer_for(division)
    return nil unless division.upcoming_event

    date = "the #{division.upcoming_event.date.day.ordinalize} of #{division.upcoming_event.date.strftime('%B')}"

    case scope
    when "bank-holidays"
      title = I18n.t(division.title, locale: :en)
      body = "The next bank holiday in #{title} is #{division.upcoming_event.title} on #{date}"
    when "when-do-the-clocks-change"
      title = content_item[:title]
      body = "The #{division.upcoming_event.notes.gsub(' one hour', '').downcase} on #{date}"
    end

    {
      "@type" => "Question",
      "name" => title,
      "acceptedAnswer" => {
        "@type" => "Answer",
        "text" => body,
      },
    }
  end

  def logo_url
    view_context.image_url("govuk_publishing_components/govuk-logo.png")
  end
end
