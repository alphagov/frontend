namespace :panopticon do
  desc "Register application metadata with panopticon"
  task register: :environment do
    require 'ostruct'
    require 'gds_api/panopticon'
    logger = GdsApi::Base.logger = Logger.new(STDERR).tap { |l| l.level = Logger::INFO }
    logger.info "Registering with panopticon..."

    registerer = GdsApi::Panopticon::Registerer.new(owning_app: "frontend")

    record = OpenStruct.new(
      slug: 'help',
      title: "Help using GOV.UK",
      paths: ["/help", "/help.json"],
      prefixes: [],
      description: "Find out about GOV.UK, including the use of cookies, accessibility of the site, the privacy policy and terms and conditions of use.",
      state: "live")
    registerer.register(record)
  end
end
