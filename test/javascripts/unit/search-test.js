describe('GOVUK.search', function () {
  var $results;

  beforeEach(function () {
    $results = $('<div id="results"></div>');
    $('body').append($results);
  });

  afterEach(function () {
    $results.remove();
  });

  describe('extractSearchURLs', function () {
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
          href: 'guidance/content-design/what-is-content-design'
        });
        expect(extractedURLs[1]).toEqual({
          href: 'guidance/content-design/research-and-evidence'
        });
      });
    });

    describe('search results with inlined descoped results', function () {
      beforeEach(function () {
        $resultsList = $('<ol class="results-list">' +
                         '<li><h3><a href="guidance/content-design/what-is-content-design">Content design: planning, writing and managing content: What is content design?</a></h3></li>' +
                         '<li class="descoped-results"><div class="descope-message"><a href="/search?q=design">Display 14,128 results from all of GOV.UK</a></div><ol>' +
                           '<li><h3><a href="/search-registered-design">Search for a registered design</a></h3><p class="meta crumbtrail"><span class="visuallyhidden">Part of </span><span class="section">Business</span><span class="visuallyhidden">, </span><span class="subsection">Intellectual property</span></p><p>Find registered designs in the UK</p></li>' +
                           '<li><h3><a href="/another-design">Another design</a></h3><p class="meta crumbtrail"><span class="visuallyhidden">Part of </span><span class="section">Business</span><span class="visuallyhidden">, </span><span class="subsection">Intellectual property</span></p><p>Something about another design</p></li>' +
                         '</ol></li>' +
                         '<li><h3><a href="guidance/content-design/more-advice">More advice on content design</a></h3></li></ol>');
        $results.append($resultsList);
      });

      afterEach(function () {
        $resultsList.remove();
      });

      it('extracts all search results URLs including descoped results in order', function () {
        var extractedURLs = GOVUK.search.extractSearchURLs($resultsList);

        expect(extractedURLs.length).toEqual(4);
        expect(extractedURLs[0]).toEqual({
          href: 'guidance/content-design/what-is-content-design'
        });
        expect(extractedURLs[1]).toEqual({
          href: '/search-registered-design',
          descoped: true
        });
        expect(extractedURLs[2]).toEqual({
          href: '/another-design',
          descoped: true
        });
        expect(extractedURLs[3]).toEqual({
          href: 'guidance/content-design/more-advice'
        });
      });
    });
  });

  describe('buildSearchResultsData', function () {
    var $resultsList;

    beforeEach(function () {
      $resultsList = $('<ol class="results-list">' +
                       '<li><h3><a href="guidance/content-design/what-is-content-design">Content design: planning, writing and managing content: What is content design?</a></h3></li>' +
                       '<li class="descoped-results"><div class="descope-message"><a href="/search?q=design">Display 14,128 results from all of GOV.UK</a></div>' +
                       '<ol><li><h3><a href="/search-registered-design">Search for a registered design</a></h3><p class="meta crumbtrail"><span class="visuallyhidden">Part of </span><span class="section">Business</span><span class="visuallyhidden">, </span><span class="subsection">Intellectual property</span></p><p>Find registered designs in the UK</p></li></ol>' +
                       '</li>' +
                       '</ol>');
      $results.append($resultsList);
    });

    afterEach(function () {
      $resultsList.remove();
    });

    describe('no suggestions present', function () {
      it('returns an object with no urls present when there are no results', function () {
        expect(GOVUK.search.buildSearchResultsData([])).toEqual({'urls': []});
      });

      it('associates the results urls into the result object', function () {
        expect(GOVUK.search.buildSearchResultsData($resultsList))
          .toEqual({'urls': [
            {href: 'guidance/content-design/what-is-content-design'},
            {href: '/search-registered-design', descoped : true}
          ]});
      });
    });

    describe('suggestions present', function () {
      it('assigns the suggestions key when suggestions are present', function () {
        var $suggestion = $('<fieldset class="spelling-suggestion">' +
                            '<p>Did you mean ' +
                            '<a href="/search?o=testin&amp;q=testing">testing</a>' +
                            '</p>' +
                            '</fieldset>');
        $results.append($suggestion);

        expect(GOVUK.search.buildSearchResultsData($resultsList))
          .toEqual({
            'urls': [
              {href: 'guidance/content-design/what-is-content-design'},
              {href: '/search-registered-design', descoped : true}
            ],
            'suggestion': 'testing'
          });

        $suggestion.remove();
      });
    });
  });

  describe('extractSearchSuggestion', function () {
    it('returns null when no spelling suggestion is found', function () {
      expect(GOVUK.search.extractSearchSuggestion()).toEqual(null);
    });

    it('extracts the spelling suggestion if there is one', function () {
      var $suggestion = $('<fieldset class="spelling-suggestion">' +
                          '<p>Did you mean ' +
                          '<a href="/search?o=testin&amp;q=testing">testing</a>' +
                          '</p>' +
                          '</fieldset>');
      $results.append($suggestion);

      expect(GOVUK.search.extractSearchSuggestion()).toEqual('testing');

      $suggestion.remove();
    });
  });
});
