window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function SaveBankHolidayNation () { }

  SaveBankHolidayNation.prototype.start = function ($module) {
    var consentCookie = window.GOVUK.getConsentCookie()

    if (consentCookie && consentCookie.settings) {
      this.$module = $module[0]
      this.$module.style.display = 'block'
      this.cookie_name = 'user_nation'
      this.cookie_options = { days: 90 } // expires after 3 months
      this.cookie_value = this.$module.getAttribute('data-nation') // used for setting, is e.g. Northern_Ireland
      this.nation = this.cookie_value.replaceAll('_', ' ') // used for text display, is e.g. Northern Ireland
      this.saved_nation = this.getCookie()
      this.other_modules = document.querySelectorAll('.js-save-nation:not([data-nation=' + this.cookie_value + '])')

      this.page_content = [
        {
          description: this.$module.getAttribute('data-save-description'),
          button_aria_label: this.$module.getAttribute('data-save-button-aria-label'),
          button_text: this.$module.getAttribute('data-save-button-text'),
          button_track: 'undo-button', // this is the wrong way round, because tracking fires after we've updated this value
          link_display: 'block'
        },
        {
          description: this.$module.getAttribute('data-undo-description'),
          button_aria_label: this.$module.getAttribute('data-undo-button-aria-label'),
          button_text: this.$module.getAttribute('data-undo-button-text'),
          button_track: 'save-button',
          link_display: 'none'
        }
      ]

      this.button = this.$module.querySelector('.js-nation-button')
      this.$module.clickButton = this.clickButton.bind(this)
      this.button.addEventListener('click', this.$module.clickButton)

      if (this.saved_nation && this.saved_nation === this.cookie_value) {
        this.saved_nation = this.decodeNationCookieSafe(this.cookie_value)
        this.toggleOptions(this.$module, 1, this.nation)
        if (!window.location.hash) {
          window.location.hash = this.encodeNationAsHash(this.saved_nation)
        }
      } else {
        this.toggleOptions(this.$module, 0, this.nation)
      }
    }
  }

  // we need to keep checking the cookie value as it's possible another instance of this code has updated/deleted it
  SaveBankHolidayNation.prototype.getCookie = function () {
    return window.GOVUK.getCookie(this.cookie_name)
  }

  SaveBankHolidayNation.prototype.clickButton = function () {
    // if there is a cookie, delete it and show the question again
    if (this.getCookie() === this.cookie_value) {
      this.saved_nation = false
      this.toggleOptions(this.$module, 0, this.nation)
      window.GOVUK.deleteCookie(this.cookie_name)
    // if not, save the nation as a cookie and show current status
    } else {
      this.saved_nation = this.decodeNationCookieSafe(this.cookie_value)
      this.toggleOptions(this.$module, 1, this.nation)
      this.toggleOtherModules(0)
      window.GOVUK.setCookie(this.cookie_name, this.cookie_value, this.cookie_options)
    }
  }

  SaveBankHolidayNation.prototype.toggleOptions = function (element, option, nation) {
    var button = element.querySelector('.js-nation-button')
    var description = element.querySelector('.js-nation-description')
    var link = element.querySelector('.js-nation-link')

    button.setAttribute('aria-label', this.page_content[option].button_aria_label.replace('#', nation))
    button.innerText = this.page_content[option].button_text.replace('#', nation)
    button.setAttribute('data-track-action', this.page_content[option].button_track)
    description.innerHTML = this.page_content[option].description.replace('#', nation)
    link.style.display = this.page_content[option].link_display
  }

  SaveBankHolidayNation.prototype.toggleOtherModules = function (option) {
    for (var x = 0; x < this.other_modules.length; x++) {
      var thatNation = this.other_modules[x].getAttribute('data-nation').replaceAll('_', ' ')
      this.toggleOptions(this.other_modules[x], option, thatNation)
    }
  }

  SaveBankHolidayNation.prototype.decodeNationCookieSafe = function (nation) {
    return nation.split('_').join(' ')
  }

  SaveBankHolidayNation.prototype.encodeNationAsHash = function (nation) {
    return nation.split(' ').join('-').toLowerCase()
  }

  Modules.SaveBankHolidayNation = SaveBankHolidayNation
})(window.GOVUK.Modules)
