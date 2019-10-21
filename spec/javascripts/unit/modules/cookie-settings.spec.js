"use strict";
describe('cookieSettings', function() {
  var cookieSettings,
      container,
      element,
      confirmationContainer,
      errorContainer,
      warningContainer,
      fakePreviousURL;

  beforeEach(function() {
    GOVUK.analytics = {trackEvent: function () {}}
    cookieSettings = new GOVUK.Modules.CookieSettings()
    // Setting new cookie to make existing tests valid
    GOVUK.setCookie('cookie_preferences_set', true, { days: 365 });
    GOVUK.Modules.CookieSettings.prototype.getReferrerLink = function () {
      return fakePreviousURL
    }

    container = document.createElement('div')
    container.innerHTML =
      '<form data-module="cookie-settings">' +
        '<input type="radio" id="settings-on" name="cookies-settings" value="on">' +
        '<input type="radio" id="settings-off" name="cookies-settings" value="off">' +
        '<input type="radio" id="usage-on" name="cookies-usage" value="on">' +
        '<input type="radio" id="usage-off" name="cookies-usage" value="off">' +
        '<input type="radio" id="campaigns-on" name="cookies-campaigns" value="on">' +
        '<input type="radio" id="campaigns-off" name="cookies-campaigns" value="off">' +
        '<button id="submit-button" type="submit">Submit</button>' +
      '</form>'

    document.body.appendChild(container)

    confirmationContainer = document.createElement('div')
    confirmationContainer.style.display = "none"
    confirmationContainer.setAttribute('data-cookie-confirmation', 'true')
    confirmationContainer.innerHTML =
      '<a class="cookie-settings__prev-page" href="#">View previous page</a>'

    document.body.appendChild(confirmationContainer)


    warningContainer = document.createElement('div')
    warningContainer.setAttribute('data-cookie-warning', 'true')
    warningContainer.setAttribute('class', 'cookie-settings__warning')
    warningContainer.innerHTML =
      '<p>warning message<p>'

    document.body.appendChild(warningContainer)


    errorContainer = document.createElement('div')
    errorContainer.style.display = "none"
    errorContainer.setAttribute('data-cookie-error', 'true')
    errorContainer.setAttribute('class', 'cookie-settings__error')
    errorContainer.innerHTML =
      '<p>Please select \'On\' or \'Off\' for all cookie choices<p>'

    document.body.appendChild(errorContainer)

    element = document.querySelector('[data-module=cookie-settings]')
  });

  afterEach(function() {
    document.body.removeChild(container)
    document.body.removeChild(confirmationContainer)
    document.body.removeChild(errorContainer)
    document.body.removeChild(warningContainer)
  });

  describe('setInitialFormValues', function () {
    it('sets a consent cookie by default', function() {
      GOVUK.cookie('cookie_policy', null)

      spyOn(window.GOVUK, 'setDefaultConsentCookie').and.callThrough()
      cookieSettings.start(element)

      expect(window.GOVUK.setDefaultConsentCookie).toHaveBeenCalled()
    });

    it('sets all radio buttons to the default values', function() {
      cookieSettings.start(element)

      var radioButtons = element.querySelectorAll('input[value=on]')

      var consentCookieJSON = JSON.parse(window.GOVUK.cookie('cookie_policy'))

      for(var i = 0; i < radioButtons.length; i++) {
        var name = radioButtons[i].name.replace('cookies-', '')

        if (consentCookieJSON[name]) {
          expect(radioButtons[i].checked).toBeTruthy()
        } else {
          expect(radioButtons[i].checked).not.toBeTruthy()
        }
      }
    });
  });

  describe('submitSettingsForm', function() {
    it('updates consent cookie with any changes', function() {
      spyOn(window.GOVUK, 'setConsentCookie').and.callThrough()
      cookieSettings.start(element)

      element.querySelector('#settings-on').checked = false
      element.querySelector('#settings-off').checked = true
      element.querySelector('#usage-on').checked = true
      element.querySelector('#usage-off').checked = false
      element.querySelector('#campaigns-on').checked = true
      element.querySelector('#campaigns-off').checked = false

      var button = element.querySelector("#submit-button")
      button.click()

      var cookie = JSON.parse(GOVUK.cookie('cookie_policy'))

      expect(window.GOVUK.setConsentCookie).toHaveBeenCalledWith({"settings": false, "usage": true, "campaigns": true})
      expect(cookie['settings']).toBeFalsy()
    });

    it('sets seen_cookie_message cookie on form submit', function() {
      spyOn(window.GOVUK, 'setCookie').and.callThrough()
      cookieSettings.start(element)

      GOVUK.cookie('seen_cookie_message', null)

      expect(GOVUK.cookie('seen_cookie_message')).toEqual(null)

      var button = element.querySelector("#submit-button")
      button.click()

      expect(window.GOVUK.setCookie).toHaveBeenCalledWith("seen_cookie_message", true, { days: 365 } )
      expect(GOVUK.cookie('seen_cookie_message')).toBeTruthy()
    });

    it('fires a Google Analytics event', function() {
      spyOn(GOVUK.analytics, 'trackEvent').and.callThrough()
      cookieSettings.start(element)

      element.querySelector('#settings-on').checked = false
      element.querySelector('#settings-off').checked = true
      element.querySelector('#usage-on').checked = true
      element.querySelector('#usage-off').checked = false
      element.querySelector('#campaigns-on').checked = true
      element.querySelector('#campaigns-off').checked = false

      var button = element.querySelector("#submit-button")
      button.click()

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('cookieSettings', 'Save changes', { label: 'settings-no usage-yes campaigns-yes ' })
    });
  });

  describe('showConfirmationMessage', function () {
    it('sets the previous referrer link if one is present', function() {
      fakePreviousURL = "/student-finance"

      cookieSettings.start(element)

      var button = element.querySelector("#submit-button")
      button.click()

      var previousLink = document.querySelector('.cookie-settings__prev-page')

      expect(previousLink.style.display).toEqual("block")
      expect(previousLink.href).toContain('/student-finance')
    });

    it('does not set a referrer if one is not present', function() {
      fakePreviousURL = null

      cookieSettings.start(element)

      var button = element.querySelector("#submit-button")
      button.click()

      var previousLink = document.querySelector('.cookie-settings__prev-page')

      expect(previousLink.style.display).toEqual("none")
    });

    it('does not set a referrer if URL is the same as current page (cookies page)', function() {
      fakePreviousURL = document.location.pathname

      cookieSettings.start(element)

      var button = element.querySelector("#submit-button")
      button.click()

      var previousLink = document.querySelector('.cookie-settings__prev-page')

      expect(previousLink.style.display).toEqual("none")
    });

    it('shows a confirmation message', function() {
      var confirmationMessage = document.querySelector('[data-cookie-confirmation]')

      cookieSettings.start(element)

      var button = element.querySelector("#submit-button")
      button.click()

      expect(confirmationMessage.style.display).toEqual('block')
    });
  });


  describe('formBeforeUserSetsPreferences', function () {


    it('does not autofill any radio values', function() {
      GOVUK.setCookie('cookie_preferences_set', null);
      cookieSettings.start(element)
      var radioButtons = element.querySelectorAll('input[checked=true]')
      expect(radioButtons.length).toEqual(0);
    });

    it('does not set the cookie_preferences_set cookie on an invalid submit', function() {
      GOVUK.setCookie('cookie_preferences_set', null);
      cookieSettings.start(element)

      var button = element.querySelector("#submit-button")

      element.querySelector('#settings-off').checked = false
      element.querySelector('#settings-on').checked = false

      button.click()

      var errorMessage = document.querySelector('[data-cookie-error]')
      expect(errorMessage.style.display).toEqual('block')

      var cookie = JSON.parse(GOVUK.cookie('cookie_preferences_set'))
      expect(cookie).toBeFalsy()

    });

    it('sets the cookie_preferences_set cookie on a valid submit', function() {
      GOVUK.setCookie('cookie_preferences_set', null);
      cookieSettings.start(element)

      element.querySelector('#settings-off').checked = true
      element.querySelector('#usage-off').checked = true
      element.querySelector('#campaigns-off').checked = true

      var button = element.querySelector("#submit-button")
      button.click()

      var cookie = JSON.parse(GOVUK.cookie('cookie_preferences_set'))
      expect(cookie).toBeTruthy()
    });

  });







});

