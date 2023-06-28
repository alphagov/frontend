namespace :publishing_api do
  desc "Publish calendars"
  task publish_calendars: :environment do
    %w[bank-holidays when-do-the-clocks-change].each do |calender_name|
      calendar = Calendar.find(calender_name)
      CalendarPublisher.new(calendar).publish
    end

    I18n.locale = :cy
    CalendarPublisher.new(Calendar.find("bank-holidays"), slug: "gwyliau-banc").publish
  end
end
