require "logger"
require "external_link_registerer"

namespace :external_link_tracker do
  desc "Deploy the recommended links to external link tracker"
  task :deploy_links do
    logger = Logger.new(Rake.verbose ? STDERR : "/dev/null")
    logger.formatter = Proc.new do |severity, datetime, progname, msg|
      "[#{severity}] #{msg}\n"
    end

    links = YAML.load_file('./lib/data/external-links.yml')

    registerer = ExternalLinkRegisterer.new(logger)

    registerer.register_links(links)
  end
end
