window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  function AppBMainNavigation (module) {
    this.module = module
    this.module.button = this.module.querySelector('button')
    this.module.nav = this.module.querySelector('#app-b-main-navigation__nav')
    this.module.nav.classList.add('js-app-b-main-navigation__nav')
    this.module.button.classList.remove('js-app-b-main-navigation__button')
  }

  AppBMainNavigation.prototype.init = function () {
    this.module.button.addEventListener('click', this.toggleMenu.bind(this))
  }

  AppBMainNavigation.prototype.toggleMenu = function (e) {
    var ariaExpanded = this.module.button.getAttribute('aria-expanded') === 'true'
    this.module.nav.classList.toggle('js-app-b-main-navigation__nav')
    this.module.button.setAttribute('aria-expanded', `${!ariaExpanded}`)
  }

  Modules.AppBMainNavigation = AppBMainNavigation
})(window.GOVUK.Modules)
