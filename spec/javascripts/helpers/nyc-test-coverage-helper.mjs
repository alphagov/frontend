// This file runs in the browser.

// Ensure window.__coverage__ is always present.
window.__coverage__ ??= {};

class NycTestCoverageReporter {
  // The following method runs after every Jasmine describe block.
  static suiteDone(result) {
    // Transfer test coverage information from the browser to node.js.
    jasmine.getEnv().setSuiteProperty("__coverage__", window.__coverage__);
  }
}

jasmine.getEnv().addReporter(NycTestCoverageReporter);
