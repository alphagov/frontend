require 'registerable_campaign'

namespace :panopticon do
  desc "Register campaign pages with panopticon"
  task :register => :environment do
    require 'gds_api/panopticon'
    logger = GdsApi::Base.logger = Logger.new(STDERR).tap { |l| l.level = Logger::INFO }
    logger.info "Registering with panopticon..."

    registerer = GdsApi::Panopticon::Registerer.new(owning_app: "frontend")
    campaigns = [
      RegisterableCampaign.new({
        :title => "Automatic enrolment into a workplace pension",
        :slug => "workplacepensions",
        :need_id => "B1047",
        :description => "Workplace pensions - what it means for you"
      })
    ]

    campaigns.each do |campaign|
      registerer.register(campaign)
    end
  end
end
