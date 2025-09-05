class Consultation < ContentItem
  include Attachments
  include NationalApplicability
  include People
  include Political

  def contributors
    organisations + people
  end
end
