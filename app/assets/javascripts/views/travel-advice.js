/* global GOVUK */

(function () {
  'use strict'

  const root = this

  /* istanbul ignore next */
  if (typeof root.GOVUK === 'undefined') { root.GOVUK = {} }

  const CountryFilter = function (searchInput) {
    const enterKeyCode = 13
    const filterInst = this

    this.container = searchInput.closest('.js-travel-container')

    searchInput.addEventListener('keydown', function (event) {
      if (event.keyCode === enterKeyCode) {
        event.preventDefault()
      }
    })

    searchInput.addEventListener('keyup', function () {
      const filter = this.value
      filterInst.filterListItems(filter)
    })
    /* istanbul ignore next */
    if (this.container) {
      const countryCount = this.container.getElementsByClassName('js-country-count')[0]
      if (countryCount) {
        countryCount.setAttribute('aria-live', 'polite')
      }
    }
  }

  CountryFilter.prototype.filterHeadings = function (countryHeadings) {
    const filterInst = this

    const headingHasVisibleCountries = function (headingFirstLetter) {
      const countries = filterInst.container.querySelector('#' + headingFirstLetter.toUpperCase()).querySelectorAll('li')
      const countryList = []

      for (let i = 0; i < countries.length; i++) {
        const innerVar = countries[i].style.display === 'none' ? countries[i] : undefined
        if (innerVar) { countryList.push(innerVar) }
      }

      return countryList.length < countries.length
    }

    for (let i = 0; i < countryHeadings.length; i++) {
      const header = countryHeadings[i].textContent.match(/[A-Z]{1}$/)[0]

      if (headingHasVisibleCountries(header)) {
        countryHeadings[i].parentNode.style.display = ''
      } else {
        countryHeadings[i].parentNode.style.display = 'none'
      }
    }
  }

  CountryFilter.prototype.doesSynonymMatch = function (elem, synonym) {
    const synonyms = elem.getAttribute('data-synonyms').split('|')
    const results = []

    for (let i = 0; i < synonyms.length; i++) {
      if (synonyms[i].toLowerCase().indexOf(synonym.toLowerCase()) > -1) {
        results.push(synonyms[i])
      }
    }

    return results
  }

  CountryFilter.prototype.filterListItems = function (filter) {
    const countryHeadings = this.container.querySelectorAll('h3.countries-initial-letter')
    const listItems = this.container.querySelectorAll('ul.js-countries-list li')

    let itemsShowing = 0
    let synonymMatch = false
    const filterInst = this
    let i = 0
    let listItem = null

    for (i = 0; i < listItems.length; i++) {
      listItem = listItems[i]
      const link = listItem.getElementsByTagName('a')[0]
      listItem.textContent = ''
      listItem.appendChild(link)
      listItem.style.display = ''
    }

    filter = filter.replace(/^\s+|\s+$/g, '') // Remove whitespace
    if (filter && filter.length > 0) {
      let hideCount = 0
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
        const synonyms = filterInst.doesSynonymMatch(listItem, filter)
        if (synonyms.length > 0) {
          synonymMatch = true
          listItem.style.display = ''
          for (let j = 0; j < synonyms.length; j++) {
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

  CountryFilter.prototype.updateCounter = function (showingCount) {
    const counter = this.container.getElementsByClassName('js-country-count')[0]
    const filter = this.container.getElementsByClassName('js-filter-count')[0]

    filter.innerText = showingCount
    counter.innerHTML = counter.innerHTML.replace(/\s*results$/, '')
    // eslint-disable-next-line eqeqeq
    if (showingCount == 0) { // this is intentional type-conversion
      counter.appendChild(document.createTextNode(' results'))
    }
  }

  GOVUK.countryFilter = CountryFilter

  const inputs = root.document.querySelectorAll('input#country')
  for (let i = 0; i < inputs.length; i++) {
    /* istanbul ignore next */
    new GOVUK.countryFilter(inputs[i]) // eslint-disable-line new-cap, no-new
  }
}).call(this)
