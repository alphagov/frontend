require "test_helper"

class TestCoverageTest < ActiveSupport::TestCase
  context ".generate_included_pathnames" do
    should "only return matching pathnames" do
      ClimateControl.modify TEST_COVERAGE_INCLUDED_PATHS: "{Gemfile,test/{test_cover*,test_helper.??}}" do
        pathnames = nil
        assert_output "The following pattern has been included in test coverage: {Gemfile,test/{test_cover*,test_helper.??}}\n" do
          pathnames = TestCoverage.send(:generate_included_pathnames)
        end
        assert_includes pathnames, Rails.root.join("Gemfile")
        assert_includes pathnames, Rails.root.join("test/test_coverage.rb")
        assert_includes pathnames, Rails.root.join("test/test_coverage_test.rb")
        assert_includes pathnames, Rails.root.join("test/test_helper.rb")
        assert_not_includes pathnames, Rails.root.join("Gemfile.lock")
      end
    end
  end

  context ".generate_excluded_pathnames" do
    should "only return matching pathnames" do
      ClimateControl.modify TEST_COVERAGE_EXCLUDED_PATHS: "{Gemfile,test/{test_cover*,test_helper.??}}" do
        pathnames = nil
        assert_output "The following pattern has been excluded from test coverage: {Gemfile,test/{test_cover*,test_helper.??}}\n" do
          pathnames = TestCoverage.send(:generate_excluded_pathnames)
        end
        assert_includes pathnames, Rails.root.join("Gemfile")
        assert_includes pathnames, Rails.root.join("test/test_coverage.rb")
        assert_includes pathnames, Rails.root.join("test/test_coverage_test.rb")
        assert_includes pathnames, Rails.root.join("test/test_helper.rb")
        assert_not_includes pathnames, Rails.root.join("Gemfile.lock")
      end
    end
  end

  context ".filter" do
    setup do
      @first_pathname = Rails.root.join("tmp/first_file.rb")
      @first_source_file = mock
      @first_source_file.stubs(:filename).returns(@first_pathname.to_s)
      @second_pathname = Rails.root.join("tmp/second_file.rb")
      @second_source_file = mock
      @second_source_file.stubs(:filename).returns(@second_pathname.to_s)
      @third_pathname = Rails.root.join("/tmp/third_file.rb")
      @third_source_file = mock
      @third_source_file.stubs(:filename).returns(@third_pathname.to_s)
    end

    context "when no included and no excluded paths specified" do
      setup do
        TestCoverage.stubs(:included_pathnames).returns([])
        TestCoverage.stubs(:excluded_pathnames).returns([])
      end

      should "not filter anything" do
        assert_not TestCoverage.send(:filter, @first_source_file)
      end
    end

    context "when included path specified" do
      setup do
        TestCoverage.stubs(:included_pathnames).returns([@first_pathname])
        TestCoverage.stubs(:excluded_pathnames).returns([])
      end

      should "filter not included files" do
        assert_not TestCoverage.send(:filter, @first_source_file)
        assert TestCoverage.send(:filter, @second_source_file)
      end
    end

    context "when excluded path specified" do
      setup do
        TestCoverage.stubs(:included_pathnames).returns([])
        TestCoverage.stubs(:excluded_pathnames).returns([@first_pathname])
      end

      should "filter excluded files" do
        assert TestCoverage.send(:filter, @first_source_file)
        assert_not TestCoverage.send(:filter, @second_source_file)
      end
    end

    context "when different included and excluded paths specified" do
      setup do
        TestCoverage.stubs(:included_pathnames).returns([@first_pathname])
        TestCoverage.stubs(:excluded_pathnames).returns([@second_pathname])
      end

      should "filter non-included files" do
        assert_not TestCoverage.send(:filter, @first_source_file)
        assert TestCoverage.send(:filter, @second_source_file)
        assert TestCoverage.send(:filter, @third_source_file)
      end
    end

    context "when the same included and excluded paths" do
      setup do
        TestCoverage.stubs(:included_pathnames).returns([@first_pathname])
        TestCoverage.stubs(:excluded_pathnames).returns([@first_pathname])
      end

      should "filter all files" do
        assert TestCoverage.send(:filter, @first_source_file)
        assert TestCoverage.send(:filter, @second_source_file)
      end
    end
  end

  context ".check_test_coverage" do
    context "when code coverage percentage below threshold" do
      setup do
        ARGF.expects(:readlines).once.returns([
          "85 5",
          "5 5",
        ])
      end

      should "exit unsuccessfully" do
        assert_output "Total test coverage percentage is 90.0.\n" do
          TestCoverage.expects(:quit).with(false)
          TestCoverage.check_test_coverage
        end
      end
    end

    context "when code coverage percentage above threshold" do
      setup do
        ARGF.expects(:readlines).once.returns([
          "85 2",
          "11 2",
        ])
      end

      should "exit successfully" do
        assert_output "Total test coverage percentage is 96.0.\n" do
          TestCoverage.expects(:quit).with(true)
          TestCoverage.check_test_coverage
        end
      end
    end
  end
end
