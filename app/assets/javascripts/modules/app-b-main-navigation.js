window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  function AppBMainNavigation (module) {
    this.module = module
    this.module.button = this.module.querySelector('button')
    this.module.navContainer = this.module.querySelector('.js-app-b-main-nav__nav-container')
    this.module.buttonContainer = this.module.querySelector('.js-app-b-main-nav__button-container')
    this.module.button.classList.remove('app-b-main-nav__button--no-js')
  }

  AppBMainNavigation.prototype.init = function () {
    this.module.button.addEventListener('click', this.toggleMenu.bind(this))
  }

  AppBMainNavigation.prototype.toggleMenu = function () {
    var ariaExpanded = this.module.button.getAttribute('aria-expanded') === 'true'
    this.module.navContainer.classList.toggle('app-b-main-nav__nav-container--js-hidden')
    this.module.button.setAttribute('aria-expanded', `${!ariaExpanded}`)
    this.module.buttonContainer.classList.toggle('app-b-main-nav__button-container--collapsed')
  }

  Modules.AppBMainNavigation = AppBMainNavigation
})(window.GOVUK.Modules)
