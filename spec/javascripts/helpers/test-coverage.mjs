window.__coverage__ ??= {};

class TestCoverageReporter {
  static suiteDone(result) {
    jasmine.getEnv().setSuiteProperty("__coverage__", window.__coverage__);
  }
}

jasmine.getEnv().addReporter(TestCoverageReporter);
