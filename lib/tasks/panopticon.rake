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
      }),
      RegisterableCampaign.new({
        :title => "UK Welcomes",
        :slug => "ukwelcomes",
        :need_id => "B1048",
        :description => "UK Welcomes gives simple information on how to set up and run your business in the UK."
      }),
      RegisterableCampaign.new({
        :title => "Help with bills and energy efficiency in your home",
        :slug => "energyhelp",
        :need_id => "B1049",
        :description => "Help is available to make your home warm and cosy this winter."
      }),
      RegisterableCampaign.new({
        :title => "HMRC is closing in on undeclared income",
        :slug => "sortmytax",
        :need_id => "B1051",
        :description => "HMRC is closing in on undeclared income."
      })
    ]

    campaigns.each do |campaign|
      registerer.register(campaign)
    end
  end
end
