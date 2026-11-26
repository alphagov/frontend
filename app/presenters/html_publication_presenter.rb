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

  HEADINGS_TO_REMOVE = [
    "Figure 1: Percentage change in employment (filled jobs) within the Digital Sector and the UK overall, 2024 to 2025.",
    "Figure 3: Proportion of Digital Sector employment (filled jobs) in the Digital Subsectors, UK, 2025.",
    "Figure 4: Absolute change in employment in the Digital Subsectors, thousands of filled jobs, UK, 2024 to 2025.",
    "Figure 5: Percentage change in employment (filled jobs) in the Digital Subsectors, UK, 2024 to 2025.",
    "Figure 7: Proportion of employment (filled jobs) held by different ethnic groups, within the Digital Sector and UK overall, 2025.",
    "Figure 8: Proportion of Digital Sector employment (filled jobs) in regions of the UK, 2025.",
    "Figure 9: Percentage change in employment (filled jobs) in the Digital Sector by regions of the UK, 2024 to 2025.",
    "Figure 10: Percentage change in employment (filled jobs) in the Digital Sector by age bands, UK, 2024 to 2025.",
    "Figure 11: Proportion of Digital Sector employment (filled jobs) by age bands, UK, 2025.",
  ].freeze

  CHARTS_TO_REPLACE = [
    "https://assets.publishing.service.gov.uk/media/6aba3a2d997a4b2950ccefa7/JD24_JD25_Figure1_Overall_change.svg",
    "https://assets.publishing.service.gov.uk/media/6aba3a878cb3c0580e501244/JD24_JD25_Figure3_Subsector_proportion.svg",
    "https://assets.publishing.service.gov.uk/media/6aba3a91a9c3d267bcccef75/JD24_JD25_Figure4_absolute_change_subsectors.svg",
    "https://assets.publishing.service.gov.uk/media/6aba3a9a734e2435f202f14a/JD24_JD25_Figure5_Percent_change_Subsectors.svg",
    "https://assets.publishing.service.gov.uk/media/6aba3aaea9c3d267bcccef77/JD24_JD25_Figure7_Ethnicity.svg",
    "https://assets.publishing.service.gov.uk/media/6aba3abbfe72ed1e2b02f105/JD24_JD25_Figure8_Region_proportion.svg",
    "https://assets.publishing.service.gov.uk/media/6aba3ac5fe72ed1e2b02f106/JD24_JD25_Figure9_Percent_change_Regions.svg",
    "https://assets.publishing.service.gov.uk/media/6aba3acffe72ed1e2b02f107/JD24_JD25_Figure10_Age.svg",
    "https://assets.publishing.service.gov.uk/media/6aba3adba9c3d267bcccef78/JD24_JD25_Figure11_Age_Proportion.svg"
  ].freeze

  def remove_headings(body)
    HEADINGS_TO_REMOVE.each do |heading|
      body = body.gsub("<p><strong>#{heading}</strong></p>","")
    end
    body
  end

  def updated_charts
    [figure_1_html, figure_3_html, figure_4_html, figure_5_html, figure_7_html, figure_8_html, figure_9_html, figure_10_html, figure_11_html]
  end


  def body
    return content_item.body unless is_chart_candidate?

    body = remove_headings(content_item.body)

    CHARTS_TO_REPLACE.each_with_index do |chart_img_src, index|
      legacy_chart_html = '<figure class="image embedded"><div class="img"><img src="' + chart_img_src + '" alt=""></div></figure>'
      body = body.gsub(legacy_chart_html, updated_charts[index])
    end
    body
  end

  def figure_1_html
    GovukPublishingComponents.render(
      "govuk_publishing_components/components/chart",
      chart_id: "chart-1",
      chart_type: "column",
      heading_level: 4,
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
      heading_level: 4,
      chart_area_left: 300,
      height: 575,
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
      heading_level: 4,
      h_axis_title: "Change in Employment (1000s of filled jobs)",
      v_axis_title: "Digital subsector",
      description: "",
      hide_legend: true,
      height: 600,
      chart_area_left: 300,
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

  def figure_5_html
    GovukPublishingComponents.render(
      "govuk_publishing_components/components/chart",
      chart_id: "chart-4",
      chart_type: "bar",
      heading: "Figure 5: Percentage change in employment (filled jobs) in the Digital Subsectors, UK, 2024 to 2025.",
      heading_level: 4,
      h_axis_title: "Percentage Change (%)",
      v_axis_title: "Digital subsector",
      description: "",
      hide_legend: true,
      height: 600,
      chart_area_left: 300,
      h_axis_view_window_min: -20,
      h_axis_view_window_max: 12,
      keys: [
        "Film, TV, Video, Radio and Music",
        "Publishing (Excluding Translation and Interpretation Activities)",
        "Software Publishing",
        "Information Service Activities",
        "Telecommunications",
        "Computer Programming, Consultancy and Related Activities",
        "Wholesale of Computers and Electronics",
        "Repair of Computers and Communication Equipment",
        "Manufacturing of Electronics and Computers",
      ],
      rows: [
        {
          label: "Percentage Change (%)",
          values: [
            11.1,
            8.3,
            7.1,
            2.9,
            2.5,
            1.6,
            -8.8,
            -12.5,
            -18,
          ],
        },
      ],
    )
  end

  def figure_7_html
    GovukPublishingComponents.render(
      "govuk_publishing_components/components/chart",
      chart_id: "chart-5",
      chart_type: "bar",
      heading: "Figure 7: Proportion of employment (filled jobs) held by different ethnic groups, within the Digital Sector and UK overall, 2025.",
      heading_level: 4,
      h_axis_title: "Proportion (%)",
      v_axis_title: "Ethnic Group",
      description: "",
      hide_legend: true,
      height: 600,
      h_axis_format: "percent",
      h_axis_view_window_min: 0,
      h_axis_view_window_max: 90,
      keys: [
        "White",
        "Asian/ Asian British",
        "Black/ African/ Caribbean/ Black British",
        "Mixed/ Multiple ethnic groups",
        "Other ethnic group",
      ],
      rows: [
        {
          label: "All UK Sectors",
          values: [
            82.8,
            8.6,
            4.8,
            1.8,
            1.9,
          ],
        },
        {
          label: "Digital Sector",
          values: [
            77.7,
            13.8,
            3.7,
            2.0,
            2.9,
          ],
        },
      ],
    )
  end

  def figure_8_html
    GovukPublishingComponents.render(
      "govuk_publishing_components/components/chart",
      chart_id: "chart-6",
      chart_type: "bar",
      heading: "Figure 8: Proportion of Digital Sector employment (filled jobs) in regions of the UK, 2025.",
      heading_level: 4,
      h_axis_title: "Proportion (%)",
      v_axis_title: "Region",
      description: "",
      hide_legend: true,
      height: 600,
      h_axis_view_window_min: 0,
      h_axis_view_window_max: 30,
      keys: [
        "London",
        "South East",
        "East of England",
        "North West",
        "South West",
        "Scotland",
        "Yorkshire and The Humber",
        "West Midlands",
        "East Midlands",
        "Wales",
        "North East",
        "Northern Ireland",
      ],
      rows: [
        {
          label: "All UK Sectors",
          values: [
            15.9,
            13.8,
            9,
            10.7,
            8.8,
            8.2,
            7.9,
            8.4,
            6.9,
            4.2,
            3.5,
            2.6,
          ],
        },
        {
          label: "Digital Sector",
          values: [
            26.1,
            18.2,
            9,
            8.6,
            6.8,
            6.2,
            6.1,
            5.9,
            4.9,
            3.5,
            2.6,
            2.1,
          ],
        },
      ],
    )
  end

  def figure_9_html
    GovukPublishingComponents.render(
      "govuk_publishing_components/components/chart",
      chart_id: "chart-7",
      chart_type: "bar",
      heading: "Figure 9: Percentage change in employment (filled jobs) in the Digital Sector by regions of the UK, 2024 to 2025.",
      heading_level: 4,
      h_axis_title: "Percentage Change (%)",
      v_axis_title: "Region",
      description: "",
      hide_legend: true,
      height: 600,
      h_axis_view_window_min: -20,
      h_axis_view_window_max: 30,
      keys: [
        "North East",
        "Wales",
        "Scotland",
        "London",
        "South East",
        "East of England",
        "Yorkshire and The Humber",
        "Northern Ireland",
        "East Midlands",
        "North West",
        "South West",
        "West Midlands",
      ],
      rows: [
        {
          label: "Percentage Change (%)",
          values: [
            24.3,
            14.5,
            8.8,
            5.1,
            2.2,
            1.9,
            1.9,
            0,
            0,
            -2.5,
            -3.2,
            -13.0
          ],
        },
      ],
    )
  end

  def figure_10_html
    GovukPublishingComponents.render(
      "govuk_publishing_components/components/chart",
      chart_id: "chart-8",
      chart_type: "bar",
      heading: "Figure 10: Percentage change in employment (filled jobs) in the Digital Sector by age bands, UK, 2024 to 2025.",
      heading_level: 4,
      h_axis_title: "Percentage change (%)",
      v_axis_title: "Age band",
      description: "",
      hide_legend: true,
      height: 600,
      h_axis_view_window_min: -10,
      h_axis_view_window_max: 20,
      keys: [
        "16-24 years",
        "25-34 years",
        "35-44 years",
        "45-54 years",
        "55-64 years",
        "65 years+",
      ],
      rows: [
        {
          label: "All UK Sectors",
          values: [
            1.1,
            0.8,
            0.2,
            0.7,
            0.9,
            10.6,
          ],
        },
        {
          label: "Digital Sector",
          values: [
            8.9,
            -1,
            8.5,
            -4.9,
            6.4,
            6.8
          ],
        },
      ],
    )
  end

  def figure_11_html
    GovukPublishingComponents.render(
      "govuk_publishing_components/components/chart",
      chart_id: "chart-9",
      chart_type: "bar",
      heading: "Figure 11: Proportion of Digital Sector employment (filled jobs) by age bands, UK, 2025",
      heading_level: 4,
      h_axis_title: "Percentage change (%)",
      v_axis_title: "Age band",
      description: "",
      hide_legend: true,
      height: 600,
      h_axis_view_window_min: 0,
      h_axis_view_window_max: 30,
      keys: [
        "16-24 years",
        "25-34 years",
        "35-44 years",
        "45-54 years",
        "55-64 years",
        "65 years+",
      ],
      rows: [
        {
          label: "All UK Sectors",
          values: [
            10.6,
            22.8,
            22.3,
            22.5,
            17.2,
            4.6,
          ],
        },
        {
          label: "Digital Sector",
          values: [
            6.1,
            28.7,
            27.0,
            22.8,
            12.8,
            2.6
          ],
        },
      ],
    )
  end

  def is_chart_candidate?
    content_item.base_path == "/government/statistics/economic-estimates-employment-in-the-digital-sector-january-2025-to-december-2025/economic-estimates-employment-in-the-digital-sector-january-2025-to-december-2025"
  end
end
