class WorkingGroupPresenter < ContentItemPresenter
  include ContentsList

  def additional_headers
    additional_headers = []
    additional_headers << { "id" => "policies", "level" => 2, "text" => I18n.t("formats.working_group.policies") } if content_item.policies.any?
    additional_headers << { "id" => "contact-details", "level" => 2, "text" => I18n.t("formats.working_group.contact_details") } if content_item.email.present?
    additional_headers
  end
end
