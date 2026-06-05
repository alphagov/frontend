window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  class NestedNavigation {
    constructor (module) {
      this.module = module
    }

    init () {
      const buttons = this.module.querySelectorAll('[data-app-c-nested-navigation-button]')

      for (const button of buttons) {
        console.log(button)
        button.addEventListener('click', this.toggleMenu)
      }
    }

    toggleMenu (e) {
      const button = e.target

      const menu = button.ariaControlsElements[0]
      menu.classList.toggle('js-app-c-nested-navigation--hidden')
      const ariaExpanded = button.getAttribute('aria-expanded') === 'true'
      button.setAttribute('aria-expanded', `${!ariaExpanded}`)
    }
  }
  Modules.NestedNavigation = NestedNavigation
})(window.GOVUK.Modules)
