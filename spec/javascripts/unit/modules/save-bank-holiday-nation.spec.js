describe('Saving bank holiday locations', function () {
  var element

  beforeEach(function () {
    window.GOVUK.setCookie('cookies_policy', '{"essential":true,"settings":true,"usage":true,"campaigns":true}')
    var div = document.createElement('div')
    div.innerHTML =
      '<section class="js-save-nation" data-module="save-bank-holiday-nation" data-nation="England_and_Wales" data-nation-matches=\'["England","Wales"]\' data-save-description="Do you want to save # as your location for bank holidays?" data-save-button-aria-label="Save # as your location for bank holidays" data-save-button-text="Save" data-undo-description="You\'ve saved # as your location for bank holidays" data-undo-button-aria-label="Remove # as your saved location for bank holidays" data-undo-button-text="Undo">' +
        '<p class="js-nation-description" aria-live="polite">Do you want to save # as your location for bank holidays?</p>' +
        '<button class="js-nation-button" type="submit" aria-label="Save # as your location for bank holidays">Save</button>' +
        '<p class="js-nation-link">' +
          '<a href="#" class="govuk-link">We\'ll add a cookie to your device</a>' +
        '</p>' +
      '</section>'

    element = div.querySelector('section')
  })

  afterEach(function () {
    window.GOVUK.deleteCookie('cookies_policy')
    window.GOVUK.deleteCookie('user_nation')
    window.location.hash = ''
  })

  describe('initial state', function () {
    it('shows the bank holiday option if cookies are allowed', function () {
      new GOVUK.Modules.SaveBankHolidayNation(element).init()
      expect(element.style.display).toEqual('block')
    })

    it('doesn\'t show the bank holiday option if cookies are not allowed', function () {
      window.GOVUK.setCookie('cookies_policy', '{"essential":false,"settings":false,"usage":false,"campaigns":false}')
      new GOVUK.Modules.SaveBankHolidayNation(element).init()
      expect(element.style.display).toEqual('')
    })
  })

  describe('interacting with the button', function () {
    beforeEach(function () {
      new GOVUK.Modules.SaveBankHolidayNation(element).init()
    })

    it('saves and unsaves a nation', function () {
      var nationButton = element.querySelector('.js-nation-button')
      nationButton.click()

      expect(window.GOVUK.getCookie('user_nation')).toEqual('England_and_Wales')
      expect(element.querySelector('.js-nation-description').textContent)
        .toEqual('You\'ve saved England and Wales as your location for bank holidays')
      expect(nationButton.textContent).toEqual('Undo')
      expect(nationButton.getAttribute('aria-label')).toEqual('Remove England and Wales as your saved location for bank holidays')
      expect(element.querySelector('.js-nation-link').style.display).toEqual('none')

      nationButton.click()

      expect(window.GOVUK.getCookie('user_nation')).toEqual(null)
      expect(element.querySelector('.js-nation-description').textContent)
        .toEqual('Do you want to save England and Wales as your location for bank holidays?')
      expect(nationButton.textContent).toEqual('Save')
      expect(nationButton.getAttribute('aria-label')).toEqual('Save England and Wales as your location for bank holidays')
      expect(element.querySelector('.js-nation-link').style.display).toEqual('block')
    })
  })

  describe('having set a cookie on a previous visit', function () {
    beforeEach(function () {
      window.GOVUK.setCookie('user_nation', 'England_and_Wales')
      new GOVUK.Modules.SaveBankHolidayNation(element).init()
    })

    it('sets the state correctly', function () {
      expect(element.querySelector('.js-nation-description').textContent)
        .toEqual('You\'ve saved England and Wales as your location for bank holidays')
      expect(element.querySelector('.js-nation-button').textContent).toEqual('Undo')
      expect(element.querySelector('.js-nation-button').getAttribute('aria-label'))
        .toEqual('Remove England and Wales as your saved location for bank holidays')
      expect(element.querySelector('.js-nation-link').style.display).toEqual('none')
    })
  })

  describe('with multiple bank holiday locations', function () {
    var englandAndWalesElement
    var northernIrelandElement

    beforeEach(function () {
      window.GOVUK.setCookie('user_nation', 'Northern_Ireland')

      englandAndWalesElement = element.cloneNode(true)

      northernIrelandElement = element.cloneNode(true)
      northernIrelandElement.setAttribute('data-nation', 'Northern_Ireland')
      northernIrelandElement.setAttribute('data-nation-matches', '["Northern Ireland"]')

      document.body.appendChild(englandAndWalesElement)
      document.body.appendChild(northernIrelandElement)

      new GOVUK.Modules.SaveBankHolidayNation(englandAndWalesElement).init()
      new GOVUK.Modules.SaveBankHolidayNation(northernIrelandElement).init()
    })

    afterEach(function () {
      document.body.removeChild(englandAndWalesElement)
      document.body.removeChild(northernIrelandElement)
    })

    it('sets the state correctly', function () {
      expect(englandAndWalesElement.querySelector('.js-nation-description').textContent)
        .toEqual('Do you want to save England and Wales as your location for bank holidays?')
      expect(englandAndWalesElement.querySelector('.js-nation-button').textContent).toEqual('Save')
      expect(englandAndWalesElement.querySelector('.js-nation-button').getAttribute('aria-label'))
        .toEqual('Save England and Wales as your location for bank holidays')
      expect(englandAndWalesElement.querySelector('.js-nation-link').style.display).toEqual('block')

      expect(northernIrelandElement.querySelector('.js-nation-description').textContent)
        .toEqual('You\'ve saved Northern Ireland as your location for bank holidays')
      expect(northernIrelandElement.querySelector('.js-nation-button').textContent).toEqual('Undo')
      expect(northernIrelandElement.querySelector('.js-nation-button').getAttribute('aria-label'))
        .toEqual('Remove Northern Ireland as your saved location for bank holidays')
      expect(northernIrelandElement.querySelector('.js-nation-link').style.display).toEqual('none')
    })

    it('updates the state correctly after clicking', function () {
      var enNationButton = englandAndWalesElement.querySelector('.js-nation-button')
      enNationButton.click()

      expect(englandAndWalesElement.querySelector('.js-nation-description').textContent).toEqual('You\'ve saved England and Wales as your location for bank holidays')
      expect(enNationButton.textContent).toEqual('Undo')
      expect(enNationButton.getAttribute('aria-label'))
        .toEqual('Remove England and Wales as your saved location for bank holidays')
      expect(englandAndWalesElement.querySelector('.js-nation-link').style.display).toEqual('none')

      expect(northernIrelandElement.querySelector('.js-nation-description').textContent)
        .toEqual('Do you want to save Northern Ireland as your location for bank holidays?')
      expect(northernIrelandElement.querySelector('.js-nation-button').textContent).toEqual('Save')
      expect(northernIrelandElement.querySelector('.js-nation-button').getAttribute('aria-label'))
        .toEqual('Save Northern Ireland as your location for bank holidays')
      expect(northernIrelandElement.querySelector('.js-nation-link').style.display).toEqual('block')
    })
  })

  describe('with URL fragments', function () {
    it('appends the right URL fragment if no fragment is present', function () {
      window.GOVUK.setCookie('user_nation', 'England_and_Wales')
      new GOVUK.Modules.SaveBankHolidayNation(element).init()

      expect(window.location.hash).toEqual('#england-and-wales')
    })

    it('doesn\'t append a URL fragment if one is already present', function () {
      window.GOVUK.setCookie('user_nation', 'scotland')
      window.location.hash = '#england-and-wales'

      new GOVUK.Modules.SaveBankHolidayNation(element).init()

      expect(window.location.hash).toEqual('#england-and-wales')
    })
  })

  it('appends the correct URL fragment when the nation cookie partially matches one of the tabs', function () {
    window.GOVUK.setCookie('user_nation', 'England')

    new GOVUK.Modules.SaveBankHolidayNation(element).init()

    expect(window.location.hash).toEqual('#england-and-wales')
    expect(element.querySelector('.js-nation-description').textContent)
      .toEqual('Do you want to save England and Wales as your location for bank holidays?')
  })

  it('does not append a URL fragment when the cookie does not match one of the nations', function () {
    window.GOVUK.setCookie('user_nation', 'spooky cookie')

    new GOVUK.Modules.SaveBankHolidayNation(element).init()

    expect(window.location.hash).toEqual('')
  })
})
