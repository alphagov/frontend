class PersonPresenter < ContentItemPresenter
  def page_title_options
    super.merge(
      context: current_roles_title,
      context_locale: content_item.locale,
      lead_paragraph: nil,
    )
  end

  def current_roles_title
    content_item.current_roles.map(&:title).to_sentence(locale: content_item.locale)
  end

  def contents
    [
      {
        text: I18n.t("formats.people.biography"),
        href: "#biography",
      },
      if content_item.currently_in_a_role?
        {
          text: I18n.t("formats.roles.heading", count: content_item.current_roles.count),
          href: "#current-roles",
        }
      end,
      if content_item.has_previous_non_ministerial_roles?
        {
          text: I18n.t("formats.person.previous_roles"),
          href: "#previous-roles",
        }
      end,
      if announcements.items.present?
        {
          text: I18n.t("formats.announcement.name", count: 2),
          href: "#announcements",
        }
      end,
    ].compact
  end

  def previous_roles_items
    content_item.previous_non_ministerial_role_appointments.map do |appointment|
      {
        link: {
          text: appointment.role.title,
          path: appointment.role.base_path,
        },
        metadata: {
          appointment_duration: "#{appointment.started_on.year} to #{appointment.ended_on.year}",
        },
      }
    end
  end

  def announcements
    @announcements ||= AnnouncementsPresenter.new(content_item.slug, filter_key: "people")
  end
end
