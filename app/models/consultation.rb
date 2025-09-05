class Consultation < ContentItem
  include Attachments
  include NationalApplicability
  include People
  include Political
  include SinglePageNotificationButton

  def contributors
    organisations + people
  end
end
