
namespace :test do

  desc "Run javascript tests"
  task :javascript => :environment do
    require 'socket'
    require 'open3'

    phantomjs_requirement = Gem::Requirement.new(">= 1.3.0")
    phantomjs_version = Gem::Version.new(`phantomjs --version`.match(/\d+\.\d+\.\d+/)[0]) rescue Gem::Version.new("0.0.0")
    unless phantomjs_requirement.satisfied_by?(phantomjs_version)
      STDERR.puts "Your version of phantomjs (v#{phantomjs_version}) is not compatible with the current phantom-driver.js."
      STDERR.puts "Please upgrade your version of phantomjs to #{phantomjs_requirement} and re-run this task."
      exit 1
    end

    pid_file = Rails.root.join('tmp', 'pids', 'javascript_tests.pid')

    if File.exists?(pid_file)
      STDERR.puts "It looks like the javascript test server is running with pid #{File.read(pid_file)}."
      STDERR.puts "Please kill the server, remove the pid file from #{pid_file} and re-run this task:"
      STDERR.puts "  $ kill -INT `cat #{pid_file}`"
      exit 1
    end

    puts "Compiling the mustache templates"
    Rake::Task["shared_mustache:compile"].invoke

    puts "Starting the test server on port 3150"
    `cd #{Rails.root} && INCLUDE_JS_TEST_ASSETS=1 script/rails server -p 3150 --daemon --environment=test --pid=#{pid_file}`

    puts "Waiting for the server to come up"
    not_connected = true
    while (not_connected) do
      begin
        TCPSocket.new("127.0.0.1", 3150)
        not_connected = false
        puts "Server is up and ready"
      rescue Errno::ECONNREFUSED
        sleep 1
      end
    end

    runner = Rails.root.join('test', 'javascripts', 'support', 'TestRunner.html')
    phantom_driver = Rails.root.join('test', 'javascripts', 'support', 'run_jasmine_test.js')
    phantom_options = '--ssl-protocol=TLSv1' 

    command = "phantomjs #{phantom_options} #{phantom_driver} #{runner}"

    exit_status = 0
    Open3.popen2e(command) do |stdin, output, wait_thr|
      output.each {|line| puts line }
      exit_status = wait_thr.value.exitstatus
    end

    puts "Javascript tests failed." unless exit_status == 0

    if pid_file.exist?
      puts "Stopping the server"
      Process.kill("INT", pid_file.read.to_i)
    end

    puts "Removing compiled mustache templates"
    Rake::Task["shared_mustache:clean"].invoke

    exit exit_status
  end
end

task :default => "test:javascript"
