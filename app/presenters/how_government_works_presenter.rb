class HowGovernmentWorksPresenter < ContentItemPresenter
  def agencies_and_other_public_bodies
    "#{Integer(content_item.department_counts['agencies_and_public_bodies']).floor(-2)}+"
  end

  def contents_list
    [
      {
        href: "#who-runs-government",
        text: "Who runs government",
      },
      {
        href: "#how-government-is-run",
        text: "How government is run",
      },
      {
        href: "#civil-service",
        text: "Civil service",
      },
      {
        href: "#get-involved",
        text: "Get involved",
      },
      {
        href: "#legislation",
        text: "Legislation",
      },
      {
        href: "#access-to-information",
        text: "Access to information",
      },
      {
        href: "#devolved-government",
        text: "Devolved government",
      },
      {
        href: "#local-government",
        text: "Local government",
      },
      {
        href: "#parliament",
        text: "Parliament",
      },
      {
        href: "#history-uk-government",
        text: "History of government",
      },
    ]
  end

  def use_contextual_components?
    true
  end
end
