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

    // suspect `closest` is jQ
    this.container = input.closest('.js-travel-container')
    // also keyup
    input.keyup(function () {
      // think this can just be this.value
      var filter = this.value

      filterInst.filterListItems(filter)
      filterInst.track(filter)
    }).keypress(function (event) {
      // eslint-disable-next-line eqeqeq
      if (event.which == enterKeyCode) {
        event.preventDefault()
      }
    })

    // not 100% on what this does but it's jQ
    $('.js-country-count', this.container).attr('aria-live', 'polite')

    // need to look up document.bind
    $(document).bind('countrieslist', this.updateCounter)
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
    // I think this is the thing that I dislike most about this work and about jQ in general
    // Like how are you meant to know what this does... I mean the first bit is something like
    // docutment.getElementsByClass('js-countries-wrapper') but i don't know how to make sure
    // that those elements are divs (which is what I assume the `div` tag is doing) but the thing
    // I really dislike is how opaque the 2nd argument is... Like what is it doing...

    // console.log(this.container)
    // console.log(document.getElementsByClassName("js-countries-wrapper"))

    var countryHeadings = $('.js-countries-wrapper div', this.container).children('h3')
    var listItems = $('ul.js-countries-list li', this.container)
    var itemsToHide
    var itemsShowing
    var synonymMatch = false
    var filterInst = this

    listItems.each(function (i, item) {
      var $item = $(item)
      var link = $item.children('a')
      $item.html(link)
    }).show()

    filter = $.trim(filter)
    if (filter && filter.length > 0) {
      itemsToHide = listItems.filter(':not(:contains(' + filter + '))')
      itemsToHide.hide()
      itemsShowing = listItems.length - itemsToHide.length
      listItems.each(function (i, item) {
        var $listItem = $(item)
        var synonym = filterInst.doesSynonymMatch(item, filter)
        if (synonym) {
          synonymMatch = true
          $listItem.show().append('(' + synonym + ')')
        }
      })
      if (synonymMatch) {
        itemsShowing = listItems.filter(function () { return this.style.display !== 'none' }).length
      }
    } else {
      countryHeadings.show()
      itemsShowing = listItems.length
    }

    this.filterHeadings(countryHeadings)

    $(document).trigger('countrieslist', { count: itemsShowing })
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
