class HtmlPublicationPresenter < ContentItemPresenter
  def hide_from_search_engines?
    return false unless content_item.parent

    PublicationPresenter::PATHS_TO_HIDE.include? content_item.parent.base_path
  end

  def organisation_logos
    content_item.organisations.map do |organisation|
      {
        name: organisation.logo.formatted_title.html_safe,
        url: organisation.base_path,
        brand: organisation.brand,
        crest: organisation.logo.crest,
        image: content_item.organisations.count == 1 ? organisation.logo.image : nil,
      }
    end
  end

  def last_changed
    timestamp = display_date(content_item.public_timestamp)

    # This assumes that a translation doesn't need the date to come beforehand.
    if content_item.first_published_version
      "#{I18n.t('common.metadata.published')} #{timestamp}"
    else
      "#{I18n.t('common.metadata.updated')} #{timestamp}"
    end
  end

  def format_sub_type
    if content_item.parent && content_item.parent.document_type.present?
      content_item.parent.document_type
    else
      "publication"
    end
  end

  def full_path(request)
    request.base_url + request.path
  end

  CHART_MATCH_STRING = '<figure class="image embedded"><div class="img"><img src="https://assets.publishing.service.gov.uk/media/6aba3ae6fe72ed1e2b02f108/JD24_JD25_FigureTech_SecJ.svg" alt=""></div></figure>'

  def body
    return content_item.body unless is_chart_candidate?

    content_item.body.gsub(CHART_MATCH_STRING, chart_html)
  end

  def chart_html
    GovukPublishingComponents.render(
      "govuk_publishing_components/components/chart",
      heading: "Chart showing page views on the website in January 2015",
      h_axis_title: "Day",
      v_axis_title: "Views",
      description: "This chart shows page views for January 2015.",
      source: "GOV.UK",
      keys: %w[
        2015-01-01
        2015-01-02
        2015-01-03
        2015-01-04
        2015-01-05
        2015-01-06
        2015-01-07
        2015-01-08
        2015-01-09
        2015-01-10
      ],
      rows: [
        {
          label: "January 2015",
          values: [
            500,
            1190,
            740,
            820,
            270,
            450,
            110,
            210,
            670,
            430,
          ],
        },
      ],
    )
  end

  def is_chart_candidate?
    content_item.base_path == "/government/statistics/economic-estimates-employment-in-the-digital-sector-january-2025-to-december-2025/economic-estimates-employment-in-the-digital-sector-january-2025-to-december-2025-technical-and-quality-assurance-report"
  end
end
