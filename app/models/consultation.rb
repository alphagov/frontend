class Consultation < ContentItem
  include Attachments
  include NationalApplicability
  include People

  def contributors
    organisations + people
  end
end
