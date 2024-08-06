// This file runs in node.js.

import fsPromises from 'node:fs/promises';
import {URL} from 'node:url';
import path from 'node:path';

export default class NycTestCoverageReporter {
  // The following method runs after every Jasmine describe block.
  suiteDone({properties}) {
    this.coverage = properties?.__coverage__ || this.coverage;
  }

  jasmineDone() {
    const rootDirname = path.dirname(
      new URL(import.meta.resolve('#root/package.json')).pathname
    );
    const nycCoverageFile = path.join(rootDirname, '.nyc_output', 'out.json');
    return fsPromises.writeFile(nycCoverageFile, JSON.stringify(this.coverage));
  }
}
