// Foreign travel advice tests
var GOVUKTest = {
  countryFilter: {
    threeCategories: '<div id="W" class="list">' +
      '<h3>' +
      '<span class="govuk-visually-hidden">Countries starting with </span>W</h3>' +
      '<ul class="countries js-countries-list">' +
      '<li data-synonyms=""><a href="/foreign-travel-advice/wallis-and-futuna">Wallis and Futuna</a></li>' +
      '<li data-synonyms="Sahel"><a href="/foreign-travel-advice/western-sahara">Western Sahara</a></li>' +
      '</ul>' +
      '</div>' +
      '<div id="Y" class="list">' +
      '<h3>' +
      '<span class="govuk-visually-hidden">Countries starting with </span>Y</h3>' +
      '<ul class="countries js-countries-list">' +
      '<li data-synonyms=""><a href="/foreign-travel-advice/yemen">Yemen</a></li>' +
      '</ul>' +
      '</div>' +
      '<div id="Z" class="list">' +
      '<h3>' +
      '<span class="govuk-visually-hidden">Countries starting with </span>Z</h3>' +
      '<ul class="countries js-countries-list">' +
      '<li data-synonyms=""><a href="/foreign-travel-advice/zambia">Zambia</a></li>' +
      '<li data-synonyms=""><a href="/foreign-travel-advice/zimbabwe">Zimbabwe</a></li>' +
      '</ul>' +
      '</div>'
  }
}

GOVUKTest.countryFilter.categories = {
  allWithCountries: '<section class="countries-wrapper">' + GOVUKTest.countryFilter.threeCategories + '</section>',
  twoWithoutCountries: '<section><div id="W" class="list">' +
    '<h3>' +
    '<span class="govuk-visually-hidden">Countries starting with </span>W</h3>' +
    '<ul class="countries js-countries-list">' +
    '<li data-synonyms="" style="display:none"><a href="/foreign-travel-advice/wallis-and-futuna">Wallis and Futuna</a></li>' +
    '<li data-synonyms="Sahel" style="display:none"><a href="/foreign-travel-advice/western-sahara">Western Sahara</a></li>' +
    '</ul>' +
    '</div>' +
    '<div id="Y" class="list">' +
    '<h3>' +
    '<span class="govuk-visually-hidden">Countries starting with </span>Y</h3>' +
    '<ul class="countries js-countries-list">' +
    '<li data-synonyms="" style="display:none"><a href="/foreign-travel-advice/yemen">Yemen</a></li>' +
    '</ul>' +
    '</div>' +
    '<div id="Z" class="list">' +
    '<h3>' +
    '<span class="govuk-visually-hidden">Countries starting with </span>Z</h3>' +
    '<ul class="countries js-countries-list">' +
    '<li data-synonyms=""><a href="/foreign-travel-advice/zambia">Zambia</a></li>' +
    '<li data-synonyms=""><a href="/foreign-travel-advice/zimbabwe">Zimbabwe</a></li>' +
    '</ul>' +
    '</div></section>'
}

GOVUKTest.countryFilter.synonyms = {
  noSynonyms: '<li data-synonyms=""><a href="/foreign-travel-advice/zambia">Zambia</a></li>',
  withSaharaSynonym: '<li data-synonyms="Sahel"><a href="/foreign-travel-advice/western-sahara">Western Sahara</a></li>',
  withUSASynonym: '<li data-synonyms="United States|America|arctic" style="display: list-item;"><a href="/foreign-travel-advice/usa">USA</a></li>'
}

GOVUKTest.countryFilter.countryCounter = '<p class="js-country-count"><span class="js-filter-count"></span></p>'

/* eslint-disable new-cap */
describe('CountryFilter', function () {
  var $input,
    filter

  beforeEach(function () {
    $input = $('<input />')
  })

  afterEach(function () {
    filter = null
    $(document).unbind('countrieslist')
  })

  describe('Creating a CountryFilter instance', function () {
    it('Should require a parameter for its constructor', function () {
      var createAFilterNoParam = function () {
        filter = new GOVUK.countryFilter()
      }
      var createAFilterWithParam = function () {
        filter = new GOVUK.countryFilter($input[0])
      }

      expect(createAFilterNoParam).toThrow()
      expect(createAFilterWithParam).not.toThrow()
    })

    it('Should have the correct interface', function () {
      filter = new GOVUK.countryFilter($input[0])

      expect(filter.filterHeadings).toBeDefined()
      expect(filter.doesSynonymMatch).toBeDefined()
      expect(filter.filterListItems).toBeDefined()
      expect(filter.updateCounter).toBeDefined()
    })

    it('Should have the correct properties applied to it', function () {
      filter = new GOVUK.countryFilter($input[0])

      expect(filter.container).toBeDefined()
    })

    it('Should attach a call to its filterListItems method in the sent jQuery objects keyup method', function () {
      filter = new GOVUK.countryFilter($input[0])
      spyOn(filter, 'filterListItems')

      window.GOVUK.triggerEvent($input[0], 'keyup')

      expect(filter.filterListItems).toHaveBeenCalled()
    })

    it('Should not cancel events bound to keyup when backspace is pressed', function () {
      filter = new GOVUK.countryFilter($input[0])
      spyOn(filter, 'filterListItems')

      window.GOVUK.triggerEvent($input[0], 'keyup', { keyCode: 8 })
      expect(filter.filterListItems).toHaveBeenCalled()
    })

    it('Should prevent form submission and filtering when enter key is pressed', function () {
      filter = new GOVUK.countryFilter($input[0])
      spyOn(filter, 'filterListItems')

      window.GOVUK.triggerEvent($input[0], 'keydown', { keyCode: 13 })
      expect(filter.filterListItems).not.toHaveBeenCalled()
    })

    it('Should set aria attributes on `.js-country-count`', function () {
      var $container = $("<div class='js-travel-container' />")
      var $countriesWrapper = $("<div class='js-country-count' />")

      $container
        .append($input)
        .append($countriesWrapper)
      filter = new GOVUK.countryFilter($input[0])

      expect($countriesWrapper.attr('aria-live')).toEqual('polite')
    })
  })

  describe('CountryFilter.filterHeadings', function () {
    var $countries

    it('Should leave headings with their countries showing visible', function () {
      var $headings

      $countries = $(GOVUKTest.countryFilter.categories.allWithCountries)
      filter = new GOVUK.countryFilter($input[0])
      filter.container = $countries[0]
      $headings = $countries.find('h3')

      filter.filterHeadings($headings)
      expect($headings.filter(function () { return this.style.display !== 'none' }).length).toEqual(3)
    })

    it('Should make headings with no visible countries invisible by hiding the wrapper', function () {
      var $headings

      $countries = $(GOVUKTest.countryFilter.categories.twoWithoutCountries)
      filter = new GOVUK.countryFilter($input[0])
      filter.container = $countries[0]
      $headings = $countries.find('h3')

      filter.filterHeadings($headings)
      expect($headings.filter(function () { return this.parentNode.style.display !== 'none' }).length).toEqual(1)
    })
  })

  describe('CountryFilter.doesSynonymMatch', function () {
    var result

    beforeEach(function () {
      filter = new GOVUK.countryFilter($input[0])
    })

    it('Should not find a match on an element with no synonyms', function () {
      var element = $(GOVUKTest.countryFilter.synonyms.noSynonyms)[0]
      var synonym = 'Sahel'
      result = filter.doesSynonymMatch(element, synonym)
      expect(result).toEqual([])
    })

    it('Should find a match on an element with a single synonym equal to that sent', function () {
      var element = $(GOVUKTest.countryFilter.synonyms.withSaharaSynonym)[0]
      var synonym = 'Sahel'
      result = filter.doesSynonymMatch(element, synonym)
      expect(result).toEqual(['Sahel'])
    })

    it('Should find no match on an element with no synonyms equal to that sent', function () {
      var element = $(GOVUKTest.countryFilter.synonyms.withUSASynonym)[0]
      var synonym = 'Sahel'
      result = filter.doesSynonymMatch(element, synonym)
      expect(result).toEqual([])
    })
  })

  describe('CountryFilter.updateCounter', function () {
    var $counter

    beforeEach(function () {
      $(
        '<div class="js-travel-container">' +
          GOVUKTest.countryFilter.countryCounter +
        '</div>'
      ).append($input)

      filter = new GOVUK.countryFilter($input[0])
      $counter = $('.js-country-count', filter.container)
    })

    it('Should make the counter text match the sent number', function () {
      filter.updateCounter(27)

      expect($counter.find('.js-filter-count').text()).toBe('27')
    })

    it("Should add the word 'results' to the end of the count number if it is 0", function () {
      filter.updateCounter(0)

      expect($counter.text().match(/results$/)).not.toBeNull()
    })

    it("Should remove the word 'results' from the end of the count number once it changes from 0", function () {
      filter.updateCounter(0)
      filter.updateCounter(27)

      expect($counter.text().match(/results$/)).toBeNull()
    })
  })

  describe('CountryFilter.filterListItems', function () {
    var $countries
    var trigger = $.fn.trigger

    beforeEach(function () {
      $countries = $(GOVUKTest.countryFilter.categories.allWithCountries)
      var $counter = $(GOVUKTest.countryFilter.countryCounter)
      $('<div class="js-travel-container"></div>')
        .append($input)
        .append($countries)
        .append($counter)
      $.fn.trigger = jasmine.createSpy('triggerSpy')
      filter = new GOVUK.countryFilter($input[0])
      filter.filterHeadings = jasmine.createSpy('filterHeadings')
      spyOn(filter, 'doesSynonymMatch').and.callThrough()
    })

    afterEach(function () {
      $.fn.trigger = trigger
    })

    it('Should call filterHeadings', function () {
      filter.filterListItems('Yem')
      expect(filter.filterHeadings).toHaveBeenCalled()
    })

    it('Should call synonymDoesMatch', function () {
      filter.filterListItems('Yem')
      expect(filter.doesSynonymMatch).toHaveBeenCalled()
    })

    it('Should call synonymDoesMatch for each list item', function () {
      filter.filterListItems('Yem')
      expect(filter.doesSynonymMatch.calls.count()).toEqual(5)
    })

    it("Should only have one country visible for the 'Yem' search term", function () {
      var visibleCountries

      filter.filterListItems('Yem')
      visibleCountries = $countries
        .find('ul.js-countries-list li')
        .filter(function () { return this.style.display !== 'none' })

      expect(visibleCountries.length).toEqual(1)
    })

    it("Should only have one country visible for the 'Z' search term", function () {
      var visibleCountries

      filter.filterListItems('Z')
      visibleCountries = $countries
        .find('ul.js-countries-list li')
        .filter(function () { return this.style.display !== 'none' })
      expect(visibleCountries.length).toEqual(2)
    })
  })
})
