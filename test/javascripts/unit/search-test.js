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

    describe('no results found', function () {
      beforeEach(function () {
        GOVUK.analytics = GOVUK.analytics || { trackEvent : function(args) {} };
        spyOn(GOVUK.analytics, 'trackEvent');
        $resultsList = []
        $results.append($resultsList);
      });

      it('returns an empty array if no results found', function () {
        expect(GOVUK.search.extractSearchURLs($resultsList)).toEqual([]);
      });

      it('does not fire an event when trackSearchResultsAndSuggestions is called', function () {
        var extractedURLs = GOVUK.search.extractSearchURLs($resultsList);
        var $searchResults = $('#results .results-list');
        GOVUK.search.trackSearchResultsAndSuggestions($searchResults);
        expect(GOVUK.analytics.trackEvent).not.toHaveBeenCalled();
      });

      describe('suggestions present', function () {
        beforeEach(function () {
          var $suggestion = $('<fieldset class="spelling-suggestion">' +
                              '<p>Did you mean ' +
                              '<a href="/search?o=testin&amp;q=testing">testing</a>' +
                              '</p>' +
                              '</fieldset>');
          $results.append($suggestion);
        });

        it('assigns the suggestions key when suggestions are present', function () {
          expect(GOVUK.search.buildSearchResultsData($resultsList))
            .toEqual({
              'urls': [],
              'suggestion': 'testing'
          });
        });

        it('fires an event when trackSearchResultsAndSuggestions is called', function () {
          var extractedURLs = GOVUK.search.extractSearchURLs($resultsList);
          var $searchResults = $('#results .results-list');
          GOVUK.search.trackSearchResultsAndSuggestions($searchResults);
          expect(GOVUK.analytics.trackEvent).toHaveBeenCalled();
        });
      });
    });

    describe('simple search results list', function () {
      beforeEach(function () {
        GOVUK.analytics = GOVUK.analytics || { trackEvent : function(args) {} };
        spyOn(GOVUK.analytics, 'trackEvent');
        $resultsList = $('<ol class="results-list"><li><h3><a href="guidance/content-design/what-is-content-design">Content design: planning, writing and managing content: What is content design?</a></h3></li><li><h3><a href="guidance/content-design/research-and-evidence">Content design: planning, writing and managing content: Research and evidence</a></h3><p>Tools and evidence to back up content design decisions.</p></li></ol>');
        $results.append($resultsList);
      });

      afterEach(function () {
        $resultsList.remove();
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

      it('fires an event when trackSearchResultsAndSuggestions is called', function () {
        var extractedURLs = GOVUK.search.extractSearchURLs($resultsList);
        var $searchResults = $('#results .results-list');
        GOVUK.search.trackSearchResultsAndSuggestions($searchResults);
        expect(GOVUK.analytics.trackEvent).toHaveBeenCalled();
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

  describe('trackSearchResultsOnOrganisationFilter', function () {
    var $resultsList;

    beforeEach(function () {
      $resultsList = $('<ol class="results-list">' +
                       '<li><h3><a href="guidance/content-design/what-is-content-design">Content design: planning, writing and managing content: What is content design?</a></h3></li>' +
                       '<li><h3><a href="guidance/content-design/research-and-evidence">Content design: planning, writing and managing content: Research and evidence</a></h3><p>Tools and evidence to back up content design decisions.</p></li>' +
                       '</ol>');
      $results.append($resultsList);
    });

    afterEach(function () {
      $resultsList.remove();
    });

    it('fires an event when the results list is updated', function () {
      var $searchResults = $('#results .results-list'),
          updated = false;

      spyOn(GOVUK.search, 'trackSearchResultsAndSuggestions');

      GOVUK.search.trackSearchResultsAndSuggestionsOnPageTrack($searchResults);

      expect(
        GOVUK.search.trackSearchResultsAndSuggestions
      ).not.toHaveBeenCalled();

      $(document).trigger('liveSearch.pageTrack');

      expect(
        GOVUK.search.trackSearchResultsAndSuggestions
      ).toHaveBeenCalled();
    });
  });

  describe("enableLiveSearchCheckbox", function(){
    var $filterHTML, $resultsList;

    beforeEach(function(){
      $resultsList = $('<div class="results-block">' +
      '<div class="inner-block js-live-search-results-list">' +
      '  <div class="result-count " id="js-live-search-result-count" aria-hidden="true">' +
      '    0 results found' +
      '  </div>' +
      '  <div class="zero-results">' +
      '    <h2>Please try:</h2>' +
      '    <ul>' +
      '      <li>searching again using different words</li>' +
      '      <li>removing your filters</li>' +
      '    </ul>' +
      '    <h2>Older content</h2>' +
      '    <p>' +
      '      Not all government content published before 2010 is on GOV.UK.' +
      '      To find older content try searching <a href="http://webarchive.nationalarchives.gov.uk/adv_search/?query=Immigration%20Rules">The National Archives</a>.' +
      '    </p>' +
      '  </div>' +
      '</div>');

      $results.append($resultsList);
    });

    afterEach(function(){
      $resultsList.remove();
    });

    describe('with organisation filters present', function () {
      beforeEach(function () {
        $filterHTML = $('<div class="filter checkbox-filter js-openable-filter " tabindex="0">' +
                        '  <div class="head">' +
                        '    <span class="legend">Organisations</span>' +
                        '    <div class="controls">' +
                        '      <a class="clear-selected ">Remove filters</a>' +
                        '      <div class="toggle"></div>' +
                        '    </div>' +
                        '  </div>' +
                        '  <div class="checkbox-container" id="organisations-filter">' +
                        '    <ul>' +
                        '      <li>' +
                        '        <input type="checkbox" name="filter_organisations[]" value="land-registry" id="land-registry" checked=""><label for="land-registry">Land Registry (0)</label>' +
                        '      </li>' +
                        '      <li>' +
                        '        <input type="checkbox" name="filter_organisations[]" value="uk-visas-and-immigration" id="uk-visas-and-immigration"><label for="uk-visas-and- +immigration">UK Visas and Immigration (356)</label>' +
                        '      </li>' +
                        '      <li>' +
                        '        <input type="checkbox" name="filter_organisations[]" value="home-office" id="home-office"><label for="home-office">Home Office (319)</label>' +
                        '      </li>' +
                        '    </ul>' +
                        '  </div>' +
                        '</div>');

        $results.append($filterHTML);

        GOVUK.search.enableLiveSearchCheckbox($results);
      });

      afterEach(function () {
        $filterHTML.remove();
      });

      it('should clear the checkboxes when no results are present', function () {
        // There should be one item checked.
        expect($filterHTML.find(':checked').length).toBe(1);

        $('a.clear-selected').click();

        // There should be no items checked
        expect($filterHTML.find(':checked').length).toBe(0);
      });
    });

    describe('without organisation filters present', function () {
      beforeEach(function () {
        $filterHTML = $('<div class="filter checkbox-filter js-openable-filter " tabindex="0">' +
                        '  <div class="head">' +
                        '    <span class="legend">Organisations</span>' +
                        '    <div class="controls">' +
                        '      <a class="clear-selected ">Remove filters</a>' +
                        '      <div class="toggle"></div>' +
                        '    </div>' +
                        '  </div>' +
                        '  <div class="checkbox-container" id="organisations-filter">' +
                        '    <ul>' +
                        '      <!-- No organisation filters present -->' +
                        '    </ul>' +
                        '  </div>' +
                        '</div>');

        $results.append($filterHTML);

        spyOn(GOVUK, 'CheckboxFilter');
        GOVUK.search.enableLiveSearchCheckbox($results);
      });

      afterEach(function () {
        $filterHTML.remove();
      });

      it('should not fire the CheckboxFilter constructor', function () {
        expect(GOVUK.CheckboxFilter).not.toHaveBeenCalled();
      });
    });
  });
});
