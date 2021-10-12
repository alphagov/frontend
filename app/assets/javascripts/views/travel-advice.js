/* global GOVUK */

(function () {
  'use strict'

  var root = this
  var $ = root.jQuery

  if (typeof root.GOVUK === 'undefined') { root.GOVUK = {} }

  // I have absolutely no idea what this does...
  $.expr[':'].contains = function (obj, index, meta) {
    return (obj.textContent || obj.innerText || '').toUpperCase().indexOf(meta[3].toUpperCase()) >= 0
  }

  var CountryFilter = function (input) {
    var enterKeyCode = 13
    var filterInst = this
    var searchInput = input[0]

    if (searchInput) {
      this.container = searchInput.closest('.js-travel-container')

      if (this.container) {
        searchInput.addEventListener("keyup", (function () {
            var filter = this.value
            filterInst.filterListItems(filter)
            filterInst.track(filter)
          })
        )

        searchInput.addEventListener("keypress", (function (event) {
            // eslint-disable-next-line eqeqeq
            if (event.which == enterKeyCode) {
              event.preventDefault()
            }
          })
        )

        var countryCount = this.container.getElementsByClassName('js-country-count')[0]
        if (countryCount) {
          countryCount.setAttribute('aria-live', 'polite')
        }
      }
    }
    // This will need removing but need to know more about `this` and `bind`
    // add event listener the countries list event
    window.addEventListener('countrieslist', this.updateCounter)
    // $(document).bind('countrieslist', this.updateCounter)
  }

  CountryFilter.prototype.filterHeadings = function (countryHeadings) {
    var filterInst = this
    var headingHasVisibleCountries = function (headingFirstLetter) {
      var firstLetterDiv = document.getElementById(headingFirstLetter)

      if (firstLetterDiv) {
        var countries = firstLetterDiv.querySelectorAll("li")
        var countryList = []

        for (var i = 0; i < countries.length; i++) {
          var innerVar = countries[i].style.display === 'none' ? countries[i] : undefined
          if (innerVar) { countryList.push(innerVar) }
        }
        return countryList.length < countries.length
      }
    }

    for (var i = 0; i < countryHeadings.length; i++) {
      var header = countryHeadings[i].textContent.match(/[A-Z]{1}$/)[0]

      if (headingHasVisibleCountries(header)) {
        countryHeadings[i].parentNode.style.display = ''
      } else {
        countryHeadings[i].parentNode.style.display = 'none'
      }
    }
  }

  CountryFilter.prototype.doesSynonymMatch = function (elem, synonym) {
    var synonyms = elem.getAttribute('data-synonyms').split('|')
    var result = false
    for (var syn in synonyms) {
      if (synonyms[syn].toLowerCase().indexOf(synonym.toLowerCase()) > -1) {
        result = synonyms[syn]
      }
    };
    return result
  }

  CountryFilter.prototype.filterListItems = function (filter) {
    var jsCountryHeadings = document.getElementsByClassName('countries-initial-letter')

    var listItems = $('ul.js-countries-list li', this.container)
    var jsListItems = document.getElementsByClassName('countries-list__item')

    var itemsShowing
    var synonymMatch = false
    var filterInst = this

    for (var i = 0; i < jsListItems.length; i++) {
      jsListItems[i].style.display = ''
    }

    filter = filter.trim()

    if (filter && filter.length > 0) {

      for (var i = 0; i < jsListItems.length; i++) {
        var downcase = jsListItems[i].innerText.toLowerCase()
        if (downcase.indexOf(filter.toLowerCase()) === -1) {
          jsListItems[i].style.display = 'none'
        }
      }

      // I think the best thing to do here is just to set the synonyms as standard.
      // that way this loop can be removed and the synonym adding won't be conditional
      // on someone typing

      listItems.each(function (i, item) {
        var $listItem = $(item)
        var synonym = filterInst.doesSynonymMatch(item, filter)

        // this is going to need som work to be conditional
        if (synonym) {
          synonymMatch = true
          $listItem.show().append('(' + synonym + ')')
        }
      })
    } else {
      for (var i = 0; i < jsCountryHeadings.length; i++) {
        jsCountryHeadings[i].style.display = ''
      }
    }

    var arrayOfListItems = []
    for(var i = 0; i < jsListItems.length; i++){
      arrayOfListItems.push(jsListItems[i])
    }
    itemsShowing = arrayOfListItems.filter(function(item){return item.style.display !== 'none'}).length

    this.filterHeadings(jsCountryHeadings)

    // window govuk trigger event countries list
    window.GOVUK.triggerEvent(window, 'countriesList', { count: itemsShowing } )
    // $(document).trigger('countrieslist', { count: itemsShowing })
  }

  CountryFilter.prototype.updateCounter = function (e, eData) {
    var jsCounter = this.container.getElementsByClassName('js-country-count')[0]
    var jsFilter = this.container.getElementsByClassName('js-filter-count')[0]

    var results

    jsFilter.innerText = eData.count

    var counterHTML = jsCounter.innerHTML
    counterHTML.replace(/\sresults$/, '')
    jsCounter.innerHTML = counterHTML

    // eslint-disable-next-line eqeqeq
    if (eData.count == 0) { // this is intentional type-conversion
      results = document.createTextNode(' results')
      jsCounter.appendChild(results)
    }
  }

  CountryFilter.prototype._trackTimeout = false

  CountryFilter.prototype.track = function (search) {
    clearTimeout(this._trackTimeout)
    var pagePath = this.pagePath()
    this._trackTimeout = root.setTimeout(function () {
      if (pagePath) {
        GOVUK.analytics.trackEvent('searchBoxFilter', search, { label: pagePath, nonInteraction: true })
      }
    }, 1000)
  }

  CountryFilter.prototype.pagePath = function () {
    window.location.pathname.split('/').pop()
  }

  GOVUK.countryFilter = CountryFilter

  $('#country-filter input#country').each(function (idx, input) {
    new GOVUK.countryFilter($(input)) // eslint-disable-line new-cap, no-new
  })
}).call(this)
