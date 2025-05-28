class CallForEvidence < ContentItem
  include People
  include Political
  include SinglePageNotificationButton
  include Updatable

  def contributors
    organisations + people
  end
end
