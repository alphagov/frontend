/* istanbul ignore next */
window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  function Webchat (module) {
    this.module = module
    this.POLL_INTERVAL = 5 * 1000
    this.AJAX_TIMEOUT = 5 * 1000
    this.API_STATES = [
      'BUSY',
      'UNAVAILABLE',
      'AVAILABLE',
      'ERROR',
      'OFFLINE',
      'ONLINE'
    ]
    this.openUrl = this.module.getAttribute('data-open-url')
    this.availabilityUrl = this.module.getAttribute('data-availability-url')
    this.openButton = this.module.querySelector('.js-webchat-open-button')
    this.webchatStateClass = 'js-webchat-advisers-'
    this.intervalID = null
    this.redirect = this.module.getAttribute('data-redirect')
  }

  Webchat.prototype.init = function () {
    if (!this.availabilityUrl || !this.openUrl) {
      /* istanbul ignore next */
      throw new Error('urls for webchat not defined', window.location.href)
    }

    if (this.openButton) {
      this.openButton.addEventListener('click', this.handleOpenChat.bind(this))
    }
    this.intervalID = setInterval(this.checkAvailability.bind(this), this.POLL_INTERVAL)
    this.checkAvailability()
  }

  /* istanbul ignore next */
  Webchat.prototype.handleOpenChat = function (e) {
    e.preventDefault()
    this.redirect === 'true' ? window.location.href = this.openUrl : window.open(this.openUrl, 'newwin', 'width=366,height=516')
  }

  Webchat.prototype.checkAvailability = function () {
    var done = function () {
      if (request.readyState === 4 && request.status === 200) {
        this.apiSuccess(JSON.parse(request.response))
      } else {
        this.apiError()
      }
    }

    var request = new XMLHttpRequest()
    request.open('GET', this.availabilityUrl, true)
    request.setRequestHeader('Content-type', 'application/x-www-form-urlencoded')
    request.addEventListener('load', done.bind(this))
    request.timeout = this.AJAX_TIMEOUT
    request.send()
  }

  Webchat.prototype.apiSuccess = function (result) {
    var validState, state

    /* istanbul ignore next */
    if (Object.prototype.hasOwnProperty.call(result, 'inHOP')) {
      validState = this.API_STATES.indexOf(result.status.toUpperCase()) !== -1
      state = validState ? result.status : 'ERROR'
      if (result.inHOP === 'true') {
        if (result.availability === 'true') {
          if (result.status === 'online') {
            state = 'AVAILABLE'
          }
          if (result.status === 'busy') {
            state = 'AVAILABLE'
          }
          if (result.status === 'offline') {
            state = 'UNAVAILABLE'
          }
        } else {
          if (result.status === 'busy') {
            state = 'BUSY'
          } else {
            state = 'UNAVAILABLE'
          }
        }
      } else {
        state = 'UNAVAILABLE'
      }
    } else {
      validState = this.API_STATES.indexOf(result.response) !== -1
      state = validState ? result.response : 'ERROR'
    }
    this.advisorStateChange(state)
  }

  Webchat.prototype.apiError = function () {
    clearInterval(this.intervalID)
    this.advisorStateChange('ERROR')
  }

  Webchat.prototype.advisorStateChange = function (state) {
    state = state.toLowerCase()
    var currentState = this.module.querySelector('[class^="' + this.webchatStateClass + state + '"]')
    var allStates = this.module.querySelectorAll('[class^="' + this.webchatStateClass + '"]')

    for (var index = 0; index < allStates.length; index++) {
      allStates[index].classList.add('govuk-!-display-none')
    }
    currentState.classList.remove('govuk-!-display-none')
  }

  Modules.Webchat = Webchat
})(window.GOVUK.Modules)
