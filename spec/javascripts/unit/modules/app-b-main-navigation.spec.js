describe('Main Menu Block module', function () {
  'use strict'

  var el, module

  beforeEach(function () {
    var DOM =
      `<div class="app-b-main-nav" data-module="app-b-main-nav">
        <h2 class="govuk-visually-hidden">Secondary navigation menu</h2>
        <div class="app-b-main-nav__button-container app-b-main-nav__button-container--collapsed js-app-b-main-nav__button-container">
          <div class="govuk-width-container">
            <button type="button" class="app-b-main-nav__button app-b-main-nav__button--no-js govuk-link govuk-link--no-underline" aria-expanded="false" aria-controls="app-b-main-nav__nav-container">
              Landing page menu
            </button>
          </div>
        </div>
        <div class="app-b-main-nav__nav-container app-b-main-nav__nav-container--js-hidden govuk-width-container js-app-b-main-nav__nav-container" id="app-b-main-nav__nav-container">
          <nav aria-label="Secondary">
              <h3 class="govuk-heading-s">First heading</h3>
              <ul class="app-b-main-nav__list">
                <li class="app-b-main-nav__list-item">
                  <a class="govuk-link govuk-link--no-underline govuk-link--no-visited-state" href="/landing-page/homepage">Landing page homepage very long text here to demonstrate wrapping</a>
                </li>
              </ul>
              <h3 class="govuk-heading-s">Goals</h3>
              <ul class="app-b-main-nav__list">
                <li class="app-b-main-nav__list-item">
                  <a class="govuk-link govuk-link--no-underline govuk-link--no-visited-state" href="/landing-page/goal-1">Goal 1</a>
                </li>
              </ul>
              <h3 class="govuk-heading-s">Tasks</h3>
              <ul class="app-b-main-nav__list">
                <li class="app-b-main-nav__list-item">
                  <a class="govuk-link govuk-link--no-underline govuk-link--no-visited-state" href="/landing-page/be-kinder">Be kinder</a>
                </li>
              </ul>
          </nav>
        </div>
      </div>
      `
    el = document.createElement('div')
    el.innerHTML = DOM
    document.body.appendChild(el)
    module = new GOVUK.Modules.AppBMainNavigation(el)
    module.init()
  })

  afterEach(function () {
    document.body.removeChild(el)
  })

  it('removes the no-js class from the button on initialisation', function () {
    expect(document.querySelector('app-b-main-nav__button--no-js')).toBe(null)
  })

  it('toggles aria expanded on the button when it is clicked', function () {
    var button = el.querySelector('button')
    expect(button.getAttribute('aria-expanded')).toBe('false')
    window.GOVUK.triggerEvent(button, 'click')
    expect(button.getAttribute('aria-expanded')).toBe('true')
  })

  it('toggles the show/hide class when the button is clicked', function () {
    var button = el.querySelector('button')
    var toggledClass = '.app-b-main-nav__nav-container--js-hidden'
    expect(document.querySelector(toggledClass)).not.toBe(null)
    window.GOVUK.triggerEvent(button, 'click')
    expect(document.querySelector(toggledClass)).toBe(null)
    window.GOVUK.triggerEvent(button, 'click')
    expect(document.querySelector(toggledClass)).not.toBe(null)
  })

  it('toggles the button container border when the button is clicked', function () {
    var button = el.querySelector('button')
    var toggledClass = '.app-b-main-nav__button-container--collapsed'
    expect(document.querySelector(toggledClass)).not.toBe(null)
    window.GOVUK.triggerEvent(button, 'click')
    expect(document.querySelector(toggledClass)).toBe(null)
    window.GOVUK.triggerEvent(button, 'click')
    expect(document.querySelector(toggledClass)).not.toBe(null)
  })

  it('toggles the show/hide class when the toggleMenu function is called', function () {
    var toggledClass = '.app-b-main-nav__nav-container--js-hidden'
    expect(document.querySelector(toggledClass)).not.toBe(null)
    module.toggleMenu()
    expect(document.querySelector(toggledClass)).toBe(null)
    module.toggleMenu()
    expect(document.querySelector(toggledClass)).not.toBe(null)
  })
})
