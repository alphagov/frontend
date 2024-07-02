import fsPromises from 'node:fs/promises';
import {URL} from 'url';
import path from 'node:path';

export default class TestCoverageReporter {
  suiteDone({properties}) {
    this.coverage = properties?.__coverage__ || this.coverage;
  }

  jasmineDone() {
    const thisFileDirname = path.dirname(new URL(import.meta.url).pathname)
    const nycOutputPath = path.join(thisFileDirname, '..', '..', '..', '.nyc_output');
    const assetsPath = path.join(nycOutputPath, 'assets');
    const testCoveragePath = path.join(nycOutputPath, 'out.json');
    return Promise.all([
      fsPromises.rm(assetsPath, {recursive: true, force: true}),
      fsPromises.writeFile(testCoveragePath, JSON.stringify(this.coverage))
    ]);
  }
}
