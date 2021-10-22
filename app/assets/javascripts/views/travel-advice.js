/* global GOVUK */

(function () {
  'use strict'

  var root = this
  var $ = root.jQuery

  if (typeof root.GOVUK === 'undefined') { root.GOVUK = {} }

  $.expr[':'].contains = function (obj, index, meta) {
    return (obj.textContent || obj.innerText || '').toUpperCase().indexOf(meta[3].toUpperCase()) >= 0
  }

  var CountryFilter = function (input) {
    var enterKeyCode = 13
    var filterInst = this

    this.container = input.closest('.js-travel-container')
    input.keyup(function () {
      var filter = $(this).val()

      filterInst.filterListItems(filter)
      filterInst.track(filter)
    }).keypress(function (event) {
      // eslint-disable-next-line eqeqeq
      if (event.which == enterKeyCode) {
        event.preventDefault()
      }
    })

    $('.js-country-count', this.container).attr('aria-live', 'polite')

    $(document).bind('countrieslist', this.updateCounter)
  }

  CountryFilter.prototype.filterHeadings = function (countryHeadings) {
    var filterInst = this

    var headingHasVisibleCountries = function (headingFirstLetter) {
      var countries = filterInst.container.querySelector('#' + headingFirstLetter.toUpperCase()).querySelectorAll('li')
      var countryList = []

      for (var i = 0; i < countries.length; i++) {
        var innerVar = countries[i].style.display === 'none' ? countries[i] : undefined
        if (innerVar) { countryList.push(innerVar) }
      }

      return countryList.length < countries.length
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
    var results = []

    for (var i = 0; i < synonyms.length; i++) {
      if (synonyms[i].toLowerCase().indexOf(synonym.toLowerCase()) > -1) {
        results.push(synonyms[i])
      }
    }

    return results
  }

  CountryFilter.prototype.filterListItems = function (filter) {
    var countryHeadings = this.container.querySelectorAll('h3.countries-initial-letter')
    var listItems = this.container.querySelectorAll('ul.js-countries-list li')

    var itemsShowing = 0
    var synonymMatch = false
    var filterInst = this
    var i = 0
    var listItem = null

    for (i = 0; i < listItems.length; i++) {
      listItem = listItems[i]
      var link = listItem.getElementsByTagName('a')[0]
      listItem.textContent = ''
      listItem.appendChild(link)
      listItem.style.display = ''
    }

    filter = filter.replace(/^\s+|\s+$/g, '')
    if (filter && filter.length > 0) {
      var hideCount = 0
      for (i = 0; i < listItems.length; i++) {
        listItem = listItems[i]
        if (listItem.children[0].firstChild.textContent.toLowerCase().includes(filter.toLowerCase())) {
          listItem.style.display = ''
        } else {
          listItem.style.display = 'none'
          hideCount += 1
        }
      }
      itemsShowing = listItems.length - hideCount

      for (i = 0; i < listItems.length; i++) {
        listItem = listItems[i]
        var synonyms = filterInst.doesSynonymMatch(listItem, filter)
        if (synonyms.length > 0) {
          synonymMatch = true
          listItem.style.display = ''
          for (var j = 0; j < synonyms.length; j++) {
            listItem.appendChild(document.createTextNode('(' + synonyms[j] + ') '))
          }
        }
      }

      if (synonymMatch) {
        itemsShowing = 0
        for (i = 0; i < listItems.length; i++) {
          if (listItems[i].style.display !== 'none') {
            itemsShowing += 1
          }
        }
      }
    } else {
      for (i = 0; i < countryHeadings.length; i++) {
        countryHeadings[i].style.display = ''
      }

      itemsShowing = listItems.length
    }

    this.filterHeadings(countryHeadings)
    this.updateCounter(itemsShowing)
  }

  CountryFilter.prototype.updateCounter = function (e, eData) {
    var $counter = $('.js-country-count', this.container)
    var results

    $counter.find('.js-filter-count').text(eData.count)
    $counter.html($counter.html().replace(/\sresults$/, ''))
    // eslint-disable-next-line eqeqeq
    if (eData.count == 0) { // this is intentional type-conversion
      results = document.createTextNode(' results')
      $counter[0].appendChild(results)
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
