class Person < ContentItem
  Organisation = Data.define(:title, :base_path)
  Role = Data.define(:title, :base_path, :document_type, :body, :parent_organisations)
  RoleAppointment = Data.define(:role, :started_on, :ended_on, :current, :order)

  def currently_in_a_role?
    current_roles.any?
  end

  def current_roles
    current_role_appointments.map(&:role)
  end

  def previous_non_ministerial_role_appointments
    role_appointments
      .select { |appointment| appointment.ended_on.present? && appointment.role.document_type != "ministerial_role" }
      .sort_by(&:started_on)
      .reverse
  end

  def has_previous_non_ministerial_roles?
    previous_non_ministerial_role_appointments.any?
  end

  def image_url
    image&.dig("url")
  end

  def slug
    base_path.split("/").last
  end

private

  def current_role_appointments
    role_appointments
      .select(&:current)
      .sort_by(&:order)
  end

  def role_appointments
    @role_appointments ||= links&.fetch("role_appointments", [])&.filter_map do |appointment|
      role_data = appointment.dig("links", "role", 0)
      next unless role_data

      RoleAppointment.new(
        role: build_role(role_data),
        started_on: parse_date(appointment.dig("details", "started_on")),
        ended_on: parse_date(appointment.dig("details", "ended_on")),
        current: appointment.dig("details", "current"),
        order: appointment.dig("details", "person_appointment_order"),
      )
    end || []
  end

  def build_role(role_data)
    Role.new(
      title: role_data["title"],
      base_path: role_data["base_path"],
      document_type: role_data["document_type"],
      body: role_data.dig("details", "body"),
      parent_organisations: role_data.dig("links", "ordered_parent_organisations")&.map do |organisation|
        Organisation.new(title: organisation["title"], base_path: organisation["base_path"])
      end || [],
    )
  end

  def parse_date(value)
    Time.zone.parse(value) if value.present?
  end
end
