// Foreign travel advice tests
function getVisibleCountries (countries) {
  var visibleCountries = Array.from(countries.querySelectorAll('ul.js-countries-list li'))
  return visibleCountries.filter((country) => country.style.display !== 'none')
}

var GOVUKTest = {
  countryFilter: {
    threeCategories: '<div id="W" class="list">' +
      '<h3 class="countries-initial-letter">' +
      '<span class="govuk-visually-hidden">Countries starting with </span>W</h3>' +
      '<ul class="countries js-countries-list">' +
      '<li data-synonyms=""><a href="/foreign-travel-advice/wallis-and-futuna">Wallis and Futuna</a></li>' +
      '<li data-synonyms="Sahel"><a href="/foreign-travel-advice/western-sahara">Western Sahara</a></li>' +
      '</ul>' +
      '</div>' +
      '<div id="Y" class="list">' +
      '<h3 class="countries-initial-letter">' +
      '<span class="govuk-visually-hidden">Countries starting with </span>Y</h3>' +
      '<ul class="countries js-countries-list">' +
      '<li data-synonyms=""><a href="/foreign-travel-advice/yemen">Yemen</a></li>' +
      '</ul>' +
      '</div>' +
      '<div id="Z" class="list">' +
      '<h3 class="countries-initial-letter">' +
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
  var input,
    filter

  beforeEach(function () {
    input = document.createElement('input')
  })

  afterEach(function () {
    input.remove()
    filter = null
  })

  describe('Creating a CountryFilter instance', function () {
    it('Should require a parameter for its constructor', function () {
      var createAFilterNoParam = function () {
        filter = new GOVUK.countryFilter()
      }
      var createAFilterWithParam = function () {
        filter = new GOVUK.countryFilter(input)
      }

      expect(createAFilterNoParam).toThrow()
      expect(createAFilterWithParam).not.toThrow()
    })

    it('Should have the correct interface', function () {
      filter = new GOVUK.countryFilter(input)

      expect(filter.filterHeadings).toBeDefined()
      expect(filter.doesSynonymMatch).toBeDefined()
      expect(filter.filterListItems).toBeDefined()
      expect(filter.updateCounter).toBeDefined()
    })

    it('Should have the correct properties applied to it', function () {
      filter = new GOVUK.countryFilter(input)

      expect(filter.container).toBeDefined()
    })

    it('Should attach a call to its filterListItems method in the sent keyup event', function () {
      filter = new GOVUK.countryFilter(input)
      spyOn(filter, 'filterListItems')

      window.GOVUK.triggerEvent(input, 'keyup')

      expect(filter.filterListItems).toHaveBeenCalled()
    })

    it('Should not cancel events bound to keyup when backspace is pressed', function () {
      filter = new GOVUK.countryFilter(input)
      spyOn(filter, 'filterListItems')

      window.GOVUK.triggerEvent(input, 'keyup', { keyCode: 8 })
      expect(filter.filterListItems).toHaveBeenCalled()
    })

    it('Should prevent form submission and filtering when enter key is pressed', function () {
      filter = new GOVUK.countryFilter(input)
      spyOn(filter, 'filterListItems')

      window.GOVUK.triggerEvent(input, 'keydown', { keyCode: 13 })
      expect(filter.filterListItems).not.toHaveBeenCalled()
    })

    it('Should work normally for another key pressed', function () {
      filter = new GOVUK.countryFilter(input)
      spyOn(filter, 'filterListItems')

      window.GOVUK.triggerEvent(input, 'keydown', { keyCode: 65 })
      expect(filter.filterListItems).not.toHaveBeenCalled()
    })

    it('Should set aria attributes on `.js-country-count`', function () {
      var container = document.createElement('div')
      container.classList.add('js-travel-container')

      var countriesWrapper = document.createElement('div')
      countriesWrapper.classList.add('js-country-count')

      container.append(input, countriesWrapper)

      filter = new GOVUK.countryFilter(input)

      expect(countriesWrapper.getAttribute('aria-live')).toEqual('polite')
    })
  })

  describe('CountryFilter.filterHeadings', function () {
    var countries

    it('Should leave headings with their countries showing visible', function () {
      countries = document.createElement('div')
      countries.innerHTML = GOVUKTest.countryFilter.categories.allWithCountries

      filter = new GOVUK.countryFilter(input)
      filter.container = countries

      var headings = Array.from(countries.querySelectorAll('h3'))

      filter.filterHeadings(headings)

      var visibleHeadings = headings.filter((heading) => heading.style.display !== 'none')
      expect(visibleHeadings.length).toEqual(3)
    })

    it('Should make headings with no visible countries invisible by hiding the wrapper', function () {
      countries = document.createElement('div')
      countries.innerHTML = GOVUKTest.countryFilter.categories.twoWithoutCountries

      filter = new GOVUK.countryFilter(input)
      filter.container = countries

      var headings = Array.from(countries.querySelectorAll('h3'))

      filter.filterHeadings(headings)

      var headingsWithoutCountries = headings.filter((heading) => heading.parentNode.style.display !== 'none')
      expect(headingsWithoutCountries.length).toEqual(1)
    })
  })

  describe('CountryFilter.doesSynonymMatch', function () {
    var result

    beforeEach(function () {
      filter = new GOVUK.countryFilter(input)
    })

    it('Should not find a match on an element with no synonyms', function () {
      var element = document.createElement('ul')
      element.innerHTML = GOVUKTest.countryFilter.synonyms.noSynonyms
      var synonym = 'Sahel'
      result = filter.doesSynonymMatch(element.firstChild, synonym)
      expect(result).toEqual([])
    })

    it('Should find a match on an element with a single synonym equal to that sent', function () {
      var element = document.createElement('ul')
      element.innerHTML = GOVUKTest.countryFilter.synonyms.withSaharaSynonym
      var synonym = 'Sahel'
      result = filter.doesSynonymMatch(element.firstChild, synonym)
      expect(result).toEqual(['Sahel'])
    })

    it('Should find no match on an element with no synonyms equal to that sent', function () {
      var element = document.createElement('ul')
      element.innerHTML = GOVUKTest.countryFilter.synonyms.withUSASynonym
      var synonym = 'Sahel'
      result = filter.doesSynonymMatch(element.firstChild, synonym)
      expect(result).toEqual([])
    })
  })

  describe('CountryFilter.updateCounter', function () {
    var counter

    beforeEach(function () {
      var container = document.createElement('div')
      container.classList.add('js-travel-container')
      container.innerHTML = GOVUKTest.countryFilter.countryCounter
      container.appendChild(input)

      filter = new GOVUK.countryFilter(input)

      counter = document.createDocumentFragment()
      counter.innerHTML = filter.container
      container.appendChild(counter)
      counter = container.querySelector('.js-country-count')
    })

    it('Should make the counter text match the sent number', function () {
      filter.updateCounter(27)

      expect(counter.querySelector('.js-filter-count').textContent).toBe('27')
    })

    it("Should add the word 'results' to the end of the count number if it is 0", function () {
      filter.updateCounter(0)

      expect(counter.textContent.match(/results$/)).not.toBeNull()
    })

    it("Should remove the word 'results' from the end of the count number once it changes from 0", function () {
      filter.updateCounter(0)
      filter.updateCounter(27)

      expect(counter.textContent.match(/results$/)).toBeNull()
    })
  })

  describe('CountryFilter.filterListItems', function () {
    var countries
    var container

    beforeEach(function () {
      container = document.createElement('div')
      container.classList.add('js-travel-container')
      container.innerHTML = `
        ${GOVUKTest.countryFilter.categories.allWithCountries}
        ${GOVUKTest.countryFilter.countryCounter}
      `
      container.prepend(input)
      filter = new GOVUK.countryFilter(input)
      filter.filterHeadings = jasmine.createSpy('filterHeadings')
      spyOn(filter, 'doesSynonymMatch').and.callThrough()
      countries = container.querySelector('.countries-wrapper')
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
      filter.filterListItems('Yem')
      expect(getVisibleCountries(countries).length).toEqual(1)
    })

    it("Should only have one country visible for the 'Z' search term", function () {
      filter.filterListItems('Z')
      expect(getVisibleCountries(countries).length).toEqual(2)
    })

    it("Should only have one country visible for the 'Sahe' search term", function () {
      filter.filterListItems('Sahe')
      expect(getVisibleCountries(countries).length).toEqual(1)
    })

    it('Should have all countries for empty search term', function () {
      filter.filterListItems('')
      expect(getVisibleCountries(countries).length).toEqual(5)
    })
  })
})
