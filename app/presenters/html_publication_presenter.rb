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

  FIGURE_1_MATCH_STRING = '<figure class="image embedded"><div class="img"><img src="https://assets.publishing.service.gov.uk/media/6aba3a2d997a4b2950ccefa7/JD24_JD25_Figure1_Overall_change.svg" alt=""></div></figure>'
  FIGURE_3_MATCH_STRING = '<figure class="image embedded"><div class="img"><img src="https://assets.publishing.service.gov.uk/media/6aba3a878cb3c0580e501244/JD24_JD25_Figure3_Subsector_proportion.svg" alt=""></div></figure>'
  FIGURE_4_MATCH_STRING = '<figure class="image embedded"><div class="img"><img src="https://assets.publishing.service.gov.uk/media/6aba3a91a9c3d267bcccef75/JD24_JD25_Figure4_absolute_change_subsectors.svg" alt=""></div></figure>'

  def body
    return content_item.body unless is_chart_candidate?

    updated_body = content_item.body
    updated_body = updated_body.gsub(FIGURE_1_MATCH_STRING, figure_1_html)
    updated_body = updated_body.gsub(FIGURE_3_MATCH_STRING, figure_3_html)
    updated_body.gsub(FIGURE_4_MATCH_STRING, figure_4_html)
  end

  def figure_1_html
    GovukPublishingComponents.render(
      "govuk_publishing_components/components/chart",
      chart_id: "chart-1",
      chart_type: "column",
      heading: "Figure 1: Percentage change in employment (filled jobs) within the Digital Sector and the UK overall, 2024 to 2025.",
      h_axis_title: "Sector",
      v_axis_title: "Percentage Change (%)",
      v_axis_format: "percent",
      description: "",
      hide_legend: true,
      keys: [
        "Digital Sector",
        "All UK Sectors",
      ],
      rows: [
        {
          label: "Percentage Change (%)",
          values: [
            2.1,
            1.1,
          ],
        },
      ],
    )
  end

  def figure_3_html
    GovukPublishingComponents.render(
      "govuk_publishing_components/components/chart",
      chart_id: "chart-2",
      chart_type: "bar",
      heading: "Figure 3: Proportion of Digital Sector employment (filled jobs) in the Digital Subsectors, UK, 2025.",
      h_axis_title: "Proportion (%)",
      v_axis_title: "Digital subsector",
      description: "",
      hide_legend: true,
      keys: [
        "Computer Programming, Consultancy and Related Activities",
        "Film, TV, Video, Radio and Music",
        "Telecommunications",
        "Publishing (Excluding Translation and Interpretation Activities)",
        "Manufacturing of Electronics and Computers",
        "Software Publishing",
        "Information Service Activities",
        "Wholesale of Computers and Electronics",
        "Repair of Computers and Communication Equipment",
      ],
      rows: [
        {
          label: "Proportion (%)",
          values: [
            58.1,
            12.7,
            9.2,
            8,
            4.5,
            2.5,
            2,
            1.7,
            1.2,
          ],
        },
      ],
    )
  end

  def figure_4_html
    GovukPublishingComponents.render(
      "govuk_publishing_components/components/chart",
      chart_id: "chart-3",
      chart_type: "bar",
      heading: "Figure 4: Absolute change in employment in the Digital Subsectors, thousands of filled jobs, UK, 2024 to 2025.",
      h_axis_title: "Change in Employment (1000s of filled jobs)",
      v_axis_title: "Digital subsector",
      description: "",
      hide_legend: true,
      height: 500,
      h_axis_view_window_min: -20,
      h_axis_view_window_max: 30,
      keys: [
        "Film, TV, Video, Radio and Music",
        "Computer Programming, Consultancy and Related Activities",
        "Publishing (Excluding Translation and Interpretation Activities)",
        "Telecommunications",
        "Software Publishing",
        "Information Service Activities",
        "Repair of Computers and Communication Equipment",
        "Wholesale of Computers and Electronics",
        "Manufacturing of Electronics and Computers",
      ],
      rows: [
        {
          label: "Change in Employment (1000s of filled jobs)",
          values: [
            23,
            17,
            11,
            4,
            3,
            1,
            -3,
            -3,
            -18,
          ],
        },
      ],
    )
  end

  def is_chart_candidate?
    content_item.base_path == "/government/statistics/economic-estimates-employment-in-the-digital-sector-january-2025-to-december-2025/economic-estimates-employment-in-the-digital-sector-january-2025-to-december-2025"
  end
end
