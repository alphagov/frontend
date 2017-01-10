namespace :rummager do
  task :index do
    Rake::Task["rummager:index_special_routes"].invoke
  end

  task index_special_routes: :environment do
    require 'gds_api/rummager'
    rummager = GdsApi::Rummager.new(ENV["RUMMAGER_HOST"] || Plek.new.find('search'))

    rummager_payloads = [
      {
        title: "Find your local council",
        description: "Find your local authority in England, Wales, Scotland and Northern Ireland",
        link: "/find-local-council",
        indexable_content: "Find your local authority in England, Wales, Scotland and Northern Ireland",
        public_timestamp: Time.zone.now.iso8601,
      },
    ]

    rummager_payloads.each do |rummager_payload|
      rummager.add_document('edition', rummager_payload[:link], rummager_payload)
    end
  end
end
