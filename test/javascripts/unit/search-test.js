describe('Search', function () {
  var $results;

  beforeEach(function () {
    $results = $('<div id="results"></div>');
    $('body').append($results);
  });

  afterEach(function () {
    $results.remove();
  });

  describe('ExtractSearchURLs', function () {
    var $resultsList;

    describe('simple search results list', function () {
      beforeEach(function () {
        $resultsList = $('<ol class="results-list"><li><h3><a href="guidance/content-design/what-is-content-design">Content design: planning, writing and managing content: What is content design?</a></h3></li><li><h3><a href="guidance/content-design/research-and-evidence">Content design: planning, writing and managing content: Research and evidence</a></h3><p>Tools and evidence to back up content design decisions.</p></li></ol>');
        $results.append($resultsList);
      });

      afterEach(function () {
        $resultsList.remove();
      });

      it('returns an empty array if no results found', function () {
        expect(GOVUK.search.extractSearchURLs([])).toEqual([]);
      });

      it('extracts all search result URLs', function () {
        var extractedURLs = GOVUK.search.extractSearchURLs($resultsList);

        expect(extractedURLs.length).toEqual(2);
        expect(extractedURLs[0]).toEqual({
          href: 'guidance/content-design/what-is-content-design',
          scoped: false
        });
        expect(extractedURLs[1]).toEqual({
          href: 'guidance/content-design/research-and-evidence',
          scoped: false
        });
      });
    });

    describe('search results with inlined scoped results', function () {
      beforeEach(function () {
        $resultsList = $('<ol class="results-list"><li><h3><a href="guidance/content-design/what-is-content-design">Content design: planning, writing and managing content: What is content design?</a></h3></li><li class="descoped-results"><div class="descope-message"><a href="/search?q=design">Display 14,128 results from all of GOV.UK</a></div><ol><li><h3><a href="/search-registered-design">Search for a registered design</a></h3><p class="meta crumbtrail"><span class="visuallyhidden">Part of </span><span class="section">Business</span><span class="visuallyhidden">, </span><span class="subsection">Intellectual property</span></p><p>Find registered designs in the UK</p></li></ol></li></ol>');
        $results.append($resultsList);
      });

      afterEach(function () {
        $resultsList.remove();
      });

      it('extracts all search results URLs including scoped results in order', function () {
        var extractedURLs = GOVUK.search.extractSearchURLs($resultsList);

        expect(extractedURLs.length).toEqual(2);
        expect(extractedURLs[0]).toEqual({
          href: 'guidance/content-design/what-is-content-design',
          scoped: false
        });
        expect(extractedURLs[1]).toEqual({
          href: '/search-registered-design',
          scoped: true
        });
      });
    });
  });
});
