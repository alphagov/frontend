require "simplecov"

class TestCoverage
  class << self
    def start
      return if @started

      @started = true
      SimpleCov.at_exit do
        SimpleCov.result.format!
        store_coverage_percentage
      end
      SimpleCov.start "rails" do
        add_filter do |source_file|
          filter(source_file)
        end
      end
    end

    def check_test_coverage
      covered, missed = ARGF
        .readlines
        .collect { |line| line.split(" ").collect(&:to_f) }
        .reduce { |sums, stats| [sums[0] + stats[0], sums[1] + stats[1]] }
      percentage = (covered / (covered + missed)) * 100
      puts "Total test coverage percentage is #{percentage}."
      quit(percentage >= 95)
    end

  private

    def store_coverage_percentage
      statistics = SimpleCov.result.coverage_statistics[:line]
      File.write(
        Rails.root.join("coverage/statistics.txt"),
        "#{statistics.covered} #{statistics.missed}",
      )
    end

    def file_pattern_to_pathnames(pattern)
      pattern = pattern.to_s
      if pattern.present?
        Rails.root.glob(pattern)
      else
        []
      end
    end

    def generate_included_pathnames
      included_paths = ENV["TEST_COVERAGE_INCLUDED_PATHS"]
      pathnames = file_pattern_to_pathnames(included_paths)
      if pathnames.present?
        puts "The following pattern has been included in test coverage: #{included_paths}"
      end
      pathnames
    end

    def generate_excluded_pathnames
      excluded_paths = ENV["TEST_COVERAGE_EXCLUDED_PATHS"]
      pathnames = file_pattern_to_pathnames(excluded_paths)
      if pathnames.present?
        puts "The following pattern has been excluded from test coverage: #{excluded_paths}"
      end
      pathnames
    end

    def included_pathnames
      @included_pathnames ||= generate_included_pathnames
    end

    def excluded_pathnames
      @excluded_pathnames ||= generate_excluded_pathnames
    end

    def filter(source_file)
      pathname = Pathname.new(File.absolute_path(source_file.filename))
      !(
        (
          included_pathnames.empty? ||
          included_pathnames.include?(pathname)
        ) && (
          excluded_pathnames.empty? ||
          !excluded_pathnames.include?(pathname)
        )
      )
    end

    def quit(is_success)
      exit(is_success)
    end
  end
end
