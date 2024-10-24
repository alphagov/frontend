describe('Main Navigation Block module', function () {
  'use strict'

  var el, module

  beforeEach(function () {
    var DOM =
      `
        <div data-module="app-b-main-navigation">
          <h2 class="app-b-main-nav__heading govuk-heading-s">
            <span class="govuk-visually-hidden">You are currently on </span>[Place Current Menu Selection Here]
          </h2>
          <button class="app-b-main-nav__button js-app-b-main-nav__button govuk-link" aria-expanded="false" aria-controls="app-b-main-nav__nav" type="button">
            Menu </button>
          <nav id="app-b-main-nav__nav">
            <ul class="app-b-main-nav__ul ">
              <li class="app-b-main-nav__listitem app-b-main-nav__listitem--active" data-aria-current="true"> Lorem for Ipsum </li>
              <li class="app-b-main-nav__listitem">
                <a href="/ipsum-2" class="govuk-link govuk-link--no-underline">Ipsums for Lorem</a>
              </li>
              <li class="app-b-main-nav__listitem">
                <a href="/our-lorem" class="govuk-link govuk-link--no-underline">Our Lorem</a>
                <ul class="app-b-main-nav__childlist">
                  <li class="app-b-main-nav__listitem">
                    <a href="/a" class="govuk-link govuk-link--no-underline">Child 1</a>
                  </li>
                </ul>
              </li>
            </ul>
          </nav>
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

  it('adds a class to hide the nav when JS is enabled', function () {
    expect(document.querySelector('.app-b-main-nav__nav--hidden')).not.toBe(null)
  })

  it('removes a class that was hiding the Menu button for non-JS users', function () {
    expect(document.querySelector('.app-b-main-nav__button--no-js')).toBe(null)
  })

  it('toggles aria expanded on the button when it is clicked', function () {
    var button = el.querySelector('button')
    expect(button.getAttribute('aria-expanded')).toBe('false')
    window.GOVUK.triggerEvent(button, 'click')
    expect(button.getAttribute('aria-expanded')).toBe('true')
  })

  it('toggles the show/hide class when the button is clicked', function () {
    var button = el.querySelector('button')
    expect(document.querySelector('.app-b-main-nav__nav--hidden')).not.toBe(null)
    window.GOVUK.triggerEvent(button, 'click')
    expect(document.querySelector('.app-b-main-nav__nav--hidden')).toBe(null)
    window.GOVUK.triggerEvent(button, 'click')
    expect(document.querySelector('.app-b-main-nav__nav--hidden')).not.toBe(null)
  })

  it('toggles the show/hide class when the toggleMenu function is called', function () {
    expect(document.querySelector('.app-b-main-nav__nav--hidden')).not.toBe(null)
    module.toggleMenu()
    expect(document.querySelector('.app-b-main-nav__nav--hidden')).toBe(null)
    module.toggleMenu()
    expect(document.querySelector('.app-b-main-nav__nav--hidden')).not.toBe(null)
  })
})
