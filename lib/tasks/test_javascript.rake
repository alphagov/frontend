
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

    test_port = 3100
    pid_file = Rails.root.join('tmp', 'pids', 'javascript_tests.pid')

    if File.exists?(pid_file)
      STDERR.puts "It looks like the javascript test server is running with pid #{File.read(pid_file)}."
      STDERR.puts "Please kill the server, remove the pid file from #{pid_file} and re-run this task:"
      STDERR.puts "  $ kill -INT `cat #{pid_file}`"
      exit 1
    end

    at_exit do
      if pid_file.exist?
        puts "Stopping the server"
        Process.kill("INT", pid_file.read.to_i)
      end
    end

    puts "Starting the test server on port #{test_port}"
    `cd #{Rails.root} && script/rails server -p #{test_port} --daemon --environment=test --pid=#{pid_file}`

    puts "Waiting for the server to come up"
    not_connected = true
    while (not_connected) do
      begin
        TCPSocket.new("127.0.0.1", test_port)
        not_connected = false
        puts "Server is up and ready"
      rescue Errno::ECONNREFUSED
        sleep 1
      end
    end

    runner = Rails.root.join('test', 'javascripts', 'support', 'TestRunner.html')
    phantom_driver = Rails.root.join('test', 'javascripts', 'support', 'run_jasmine_test.js')

    command = "phantomjs #{phantom_driver} #{runner}"

    success = true
    Open3.popen2e(command) do |stdin, output, wait_thr|
      output.each {|line| puts line }
      success = wait_thr.value.exitstatus == 0
    end

    abort "Javascript tests failed." unless success
  end
end

task :default => "test:javascript"
