module TestJavascript
module_function

  def enure_phantomjs_version_is_correct
    phantomjs_requirement = Gem::Requirement.new(">= 1.3.0")
    phantomjs_version = Gem::Version.new(`phantomjs --version`.match(/\d+\.\d+\.\d+/)[0]) rescue Gem::Version.new("0.0.0")
    unless phantomjs_requirement.satisfied_by?(phantomjs_version)
      STDERR.puts "Your version of phantomjs (v#{phantomjs_version}) is not compatible with the current phantom-driver.js."
      STDERR.puts "Please upgrade your version of phantomjs to #{phantomjs_requirement} and re-run this task."
      exit 1
    end
  end

  def get_pid_file
    pid_file = Rails.root.join('tmp', 'pids', 'javascript_tests.pid')

    if pid_file.exist?
      STDERR.puts "It looks like the javascript test server is running with pid #{File.read(pid_file)}."
      STDERR.puts "Please kill the server, remove the pid file from #{pid_file} and re-run this task:"
      STDERR.puts "  $ kill -INT `cat #{pid_file}`"
      exit 1
    end

    pid_file
  end

  def compile_shared_mustache_templates
    puts "Compiling the mustache templates"
    Rake::Task["shared_mustache:compile"].invoke
  end

  def start_rails_server(pid_file)
    puts "Starting the test server on port 3150"
    `cd #{Rails.root} && INCLUDE_JS_TEST_ASSETS=1 script/rails server -p 3150 --daemon --environment=test --pid=#{pid_file}`

    puts "Waiting for the server to come up"
    not_connected = true
    while not_connected do
      begin
        TCPSocket.new("127.0.0.1", 3150)
        not_connected = false
        puts "Server is up and ready"
      rescue Errno::ECONNREFUSED
        sleep 1
      end
    end
  end

  def run_javascript_tests
    runner = Rails.root.join('test', 'javascripts', 'support', 'TestRunner.html')
    phantom_driver = Rails.root.join('test', 'javascripts', 'support', 'run_jasmine_test.js')
    phantom_options = '--ssl-protocol=TLSv1'

    command = "phantomjs #{phantom_options} #{phantom_driver} #{runner}"

    exit_status = 0
    Open3.popen2e(command) do |_stdin, output, wait_thr|
      output.each { |line| puts line }
      exit_status = wait_thr.value.exitstatus
    end
    puts "Javascript tests failed." unless exit_status.zero?

    exit_status
  end

  def cleanup_pid_file(pid_file)
    if pid_file.exist?
      puts "Stopping the server"
      Process.kill("INT", pid_file.read.to_i)
    end
  end

  def cleanup_shared_mustache_templates
    puts "Removing compiled mustache templates"
    Rake::Task["shared_mustache:clean"].invoke
  end
end

namespace :test do
  desc "Run javascript tests"
  task javascript: :environment do
    require 'socket'
    require 'open3'

    TestJavascript.enure_phantomjs_version_is_correct
    pid_file = TestJavascript.get_pid_file

    TestJavascript.compile_shared_mustache_templates

    TestJavascript.start_rails_server(pid_file)

    exit_status = TestJavascript.run_javascript_tests

    TestJavascript.cleanup_pid_file(pid_file)

    TestJavascript.cleanup_shared_mustache_templates

    exit exit_status
  end
end

task default: "test:javascript"
