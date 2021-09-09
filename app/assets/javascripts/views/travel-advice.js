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
      // this is just going to be a query selector for an ID I think
      // somewhat more complicated than that, I think I need to work on finding that ID bit and working out that the filterInst is...
      // var countries = $('#' + headingFirstLetter.toUpperCase(), filterInst.container)[0].querySelectorAll('li')
      var countries = $('#' + headingFirstLetter.toUpperCase(), filterInst.container).find('li')
      var thing = document.getElementById(headingFirstLetter.toUpperCase(), filterInst.container)

      return countries.map(function () {
        return this.style.display === 'none' ? this : undefined
      }).length < countries.length
    }

    countryHeadings.each(function (index, elem) {
      var header = elem.textContent.match(/[A-Z]{1}$/)[0]

      if (headingHasVisibleCountries(header)) {
        elem.parentNode.style.display = ''
      } else {
        elem.parentNode.style.display = 'none'
      }
    })
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
