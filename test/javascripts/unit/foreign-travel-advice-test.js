// Foreign travel advice tests
var GOVUK_test = {
  countryFilter: {
    categories: { 
      allWithCountries: '<section><div id="W" class="list">' +
        '<h2>' +
        '<span class="visuallyhidden">Countries starting with </span>W</h2>' +
        '<ul class="countries">' +
        '<li data-synonyms=""><a href="/foreign-travel-advice/wallis-and-futuna">Wallis and Futuna</a></li>' +
        '<li data-synonyms="Sahel"><a href="/foreign-travel-advice/western-sahara">Western Sahara</a></li>' +
        '</ul>' +
        '</div>' +
        '<div id="Y" class="list">' +
        '<h2>' +
        '<span class="visuallyhidden">Countries starting with </span>Y</h2>' +
        '<ul class="countries">' +
        '<li data-synonyms=""><a href="/foreign-travel-advice/yemen">Yemen</a></li>' +
        '</ul>' +
        '</div>' +
        '<div id="Z" class="list">' +
        '<h2>' +
        '<span class="visuallyhidden">Countries starting with </span>Z</h2>' +
        '<ul class="countries">' +
        '<li data-synonyms=""><a href="/foreign-travel-advice/zambia">Zambia</a></li>' +
        '<li data-synonyms=""><a href="/foreign-travel-advice/zimbabwe">Zimbabwe</a></li>' +
        '</ul>' +
        '</div></section>',
      twoWithoutCountries: '<section><div id="W" class="list">' +
        '<h2>' +
        '<span class="visuallyhidden">Countries starting with </span>W</h2>' +
        '<ul class="countries">' +
        '<li data-synonyms="" style="display:none"><a href="/foreign-travel-advice/wallis-and-futuna">Wallis and Futuna</a></li>' +
        '<li data-synonyms="Sahel" style="display:none"><a href="/foreign-travel-advice/western-sahara">Western Sahara</a></li>' +
        '</ul>' +
        '</div>' +
        '<div id="Y" class="list">' +
        '<h2>' +
        '<span class="visuallyhidden">Countries starting with </span>Y</h2>' +
        '<ul class="countries">' +
        '<li data-synonyms="" style="display:none"><a href="/foreign-travel-advice/yemen">Yemen</a></li>' +
        '</ul>' +
        '</div>' +
        '<div id="Z" class="list">' +
        '<h2>' +
        '<span class="visuallyhidden">Countries starting with </span>Z</h2>' +
        '<ul class="countries">' +
        '<li data-synonyms=""><a href="/foreign-travel-advice/zambia">Zambia</a></li>' +
        '<li data-synonyms=""><a href="/foreign-travel-advice/zimbabwe">Zimbabwe</a></li>' +
        '</ul>' +
        '</div></section>'
    },
    synonyms: {
      noSynonyms: '<li data-synonyms=""><a href="/foreign-travel-advice/zambia">Zambia</a></li>',
      withSaharaSynonym: '<li data-synonyms="Sahel"><a href="/foreign-travel-advice/western-sahara">Western Sahara</a></li>',
      withUSASynonym: '<li data-synonyms="United States|America|arctic" style="display: list-item;"><a href="/foreign-travel-advice/usa">USA</a></li>'
    }
  } 
};

describe("CountryFilter", function () {
  var $input,
      filter;

  describe("Creating a CountryFilter instance", function () {
    beforeEach(function () {
      $input = $('<input />');
    });

    it("Should require a parameter for its constructor", function () {
      var createAFilterNoParam = function () {
            filter = new GOVUK.countryFilter();
          },
          createAFilterWithParam = function () {
            filter = new GOVUK.countryFilter($input);
          };
    
      expect(createAFilterNoParam).toThrow();
      expect(createAFilterWithParam).not.toThrow();
    });

    it("Should have the correct interface", function () {
      filter = new GOVUK.countryFilter($input);

      expect(filter.filterHeadings).toBeDefined();
      expect(filter.doesSynonymMatch).toBeDefined();
      expect(filter.filterListItems).toBeDefined();
      expect(filter.updateCounter).toBeDefined();
    });

    it("Should have the correct properties applied to it", function () {
      filter = new GOVUK.countryFilter($input);
      
      expect(filter.container).toBeDefined();
    });

    it("Should attach a call to it's filterListItems method in the sent jQuery object's keyup method", function () {
      filter = new GOVUK.countryFilter($input);
      spyOn(filter, "filterListItems");

      $input.keyup();

      expect(filter.filterListItems).toHaveBeenCalled();
    });

    it("Should cancel events bound to keypress when enter is pressed", function () {
      var invalidEventMock = {
            "which": 8,
            "preventDefault": jasmine.createSpy("preventDefault1")
          },
          validEventMock = {
            "which": 13,
            "preventDefault": jasmine.createSpy("preventDefault2")
          },
          callback;

      $input.keypress = function (func) {
        callback = func;
      };
      filter = new GOVUK.countryFilter($input);

      // call event with backspace
      callback(invalidEventMock);
      expect(invalidEventMock.preventDefault).not.toHaveBeenCalled();

      // call event with enter
      callback(validEventMock);
      expect(validEventMock.preventDefault).toHaveBeenCalled();
    });

    it("Should set aria attributes on div.countries-wrapper", function () {
      var $container = $("<div class='inner' />"),
          $countriesWrapper = $("<div class='countries-wrapper' />");
      $input = $("<input />");

      $container
        .append($input)
        .append($countriesWrapper);
      filter = new GOVUK.countryFilter($input);

      expect($countriesWrapper.attr("aria-live")).toEqual("polite");
    });

    it("Should bind the updateCounter method to the 'countrieslist' event", function () {
      var $temp = $;

      $.fn.bind = jasmine.createSpy('bindSpy');
      
      filter = new GOVUK.countryFilter($input);
      
      expect($.fn.bind).toHaveBeenCalledWith("countrieslist", filter.updateCounter);
      $.fn.bind = $temp.fn.bind;
    });
  });

  describe("CountryFilter.filterHeadings", function () {
    var $countries;

    it("Should leave headings with their countries showing visible", function () {
      var $headings;

      $countries = $(GOVUK_test.countryFilter.categories.allWithCountries);
      filter = new GOVUK.countryFilter($input);
      filter.container = $countries;
      $headings = $countries.find('h2');

      filter.filterHeadings($headings);
      expect($headings.map(function () { if ($(this).css('display') !== 'none') { return this; }}).length).toEqual(3);
    });

    it("Should make headings with their countries hidden invisible", function () {
      var $headings;

      $countries = $(GOVUK_test.countryFilter.categories.twoWithoutCountries);
      filter = new GOVUK.countryFilter($input);
      filter.container = $countries;
      $headings = $countries.find('h2');
      
      filter.filterHeadings($headings);
      expect($headings.map(function () { if ($(this).css('display') !== 'none') { return this; }}).length).toEqual(1);
    });
  });

  describe("CountryFilter.doesSynonymMatch", function () {
    var result;

    beforeEach(function () {
      filter = new GOVUK.countryFilter($input);
    });

    it("Should not find a match on an element with no synonyms", function () {
      var element = $(GOVUK_test.countryFilter.synonyms.noSynonyms)[0],
          synonym = 'Sahel';
      result = filter.doesSynonymMatch(element, synonym);
      expect(result).toBe(false);
    });

    if("Should find a match on an element with a single synonym equal to that sent", function () {
      var element = $(GOVUK_test.countryFilter.synonyms.withSaharaSynonym)[0],
          synonym = 'Sahel';
      result = filter.doesSynonymMatch(element, synonym);
      expect(result).toBe(true);
    });

    it("Should find no match on an element with no synonyms equal to that sent", function () {
      var element = $(GOVUK_test.countryFilter.synonyms.withUSASynonym)[0],
          synonym = 'Sahel';
      result = filter.doesSynonymMatch(element, synonym);
      expect(result).toBe(false);
    });
  });
});
