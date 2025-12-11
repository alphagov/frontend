class HowGovernmentWorksPresenter < ContentItemPresenter
  def agencies_and_other_public_bodies
    "#{Integer(content_item.department_counts['agencies_and_public_bodies']).floor(-2)}+"
  end
end
