window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  function AppBMainNavigation (module) {
    this.module = module
    this.module.button = this.module.querySelector('button')
    this.module.nav = this.module.querySelector('#app-b-main-nav__nav')
    this.module.nav.classList.add('app-b-main-nav__nav--hidden')
    this.module.button.classList.remove('app-b-main-nav__button--no-js')
  }

  AppBMainNavigation.prototype.init = function () {
    this.module.button.addEventListener('click', this.toggleMenu.bind(this))
  }

  AppBMainNavigation.prototype.toggleMenu = function (e) {
    var ariaExpanded = this.module.button.getAttribute('aria-expanded') === 'true'
    this.module.nav.classList.toggle('app-b-main-nav__nav--hidden')
    this.module.button.setAttribute('aria-expanded', `${!ariaExpanded}`)
  }

  Modules.AppBMainNavigation = AppBMainNavigation
})(window.GOVUK.Modules)
