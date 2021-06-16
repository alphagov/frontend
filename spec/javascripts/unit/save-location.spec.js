describe('Saving bank holiday locations', function () {
  var $locations
  var html = '<section class="js-save-nation" data-module="save-bank-holiday-nation" data-nation="England_and_Wales" data-nation-matches=\'["England","Wales"]\' data-save-description="Do you want to save # as your location for bank holidays?" data-save-button-aria-label="Save # as your location for bank holidays" data-save-button-text="Save" data-undo-description="You\'ve saved # as your location for bank holidays" data-undo-button-aria-label="Remove # as your saved location for bank holidays" data-undo-button-text="Undo">' +
    '<p class="js-nation-description" aria-live="polite">Do you want to save # as your location for bank holidays?</p>' +
    '<button class="js-nation-button" type="submit" aria-label="Save # as your location for bank holidays">Save</button>' +
    '<p class="js-nation-link">' +
      '<a href="#" class="govuk-link">We\'ll add a cookie to your device</a>' +
    '</p>' +
  '</section>'

  beforeEach(function () {
    window.GOVUK.setCookie('cookies_policy', '{"essential":true,"settings":true,"usage":true,"campaigns":true}')
  })

  afterEach(function () {
    window.GOVUK.deleteCookie('cookies_policy')
    window.GOVUK.deleteCookie('user_nation')
    $locations.remove()
    window.location.hash = ''
  })

  describe('initial state', function () {
    beforeEach(function () {
      $locations = $(html)
      $('body').append($locations)
    })

    it('shows the bank holiday option if cookies are allowed', function () {
      var bank = new GOVUK.Modules.SaveBankHolidayNation()
      bank.start($locations)
      expect($locations[0].style.display).toEqual('block')
    })

    it('doesn\'t show the bank holiday option if cookies are not allowed', function () {
      window.GOVUK.setCookie('cookies_policy', '{"essential":false,"settings":false,"usage":false,"campaigns":false}')
      var bank = new GOVUK.Modules.SaveBankHolidayNation()
      bank.start($locations)
      expect($locations[0].style.display).toEqual('')
    })
  })

  describe('interacting with the button', function () {
    beforeEach(function () {
      $locations = $(html)
      $('body').append($locations)
      var bank = new GOVUK.Modules.SaveBankHolidayNation()
      bank.start($locations)
    })

    it('saves and unsaves a nation', function () {
      $('.js-nation-button').click()

      expect(window.GOVUK.getCookie('user_nation')).toEqual('England_and_Wales')
      expect($('.js-nation-description').text()).toEqual('You\'ve saved England and Wales as your location for bank holidays')
      expect($('.js-nation-button').text()).toEqual('Undo')
      expect($('.js-nation-button').attr('aria-label')).toEqual('Remove England and Wales as your saved location for bank holidays')
      expect($('.js-nation-link')[0].style.display).toEqual('none')

      $('.js-nation-button').click()

      expect(window.GOVUK.getCookie('user_nation')).toEqual(null)
      expect($('.js-nation-description').text()).toEqual('Do you want to save England and Wales as your location for bank holidays?')
      expect($('.js-nation-button').text()).toEqual('Save')
      expect($('.js-nation-button').attr('aria-label')).toEqual('Save England and Wales as your location for bank holidays')
      expect($('.js-nation-link')[0].style.display).toEqual('block')
    })
  })

  describe('having set a cookie on a previous visit', function () {
    beforeEach(function () {
      $locations = $(html)
      $('body').append($locations)
      window.GOVUK.setCookie('user_nation', 'England_and_Wales')
      var bank = new GOVUK.Modules.SaveBankHolidayNation()
      bank.start($locations)
    })

    it('sets the state correctly', function () {
      expect($('.js-nation-description').text()).toEqual('You\'ve saved England and Wales as your location for bank holidays')
      expect($('.js-nation-button').text()).toEqual('Undo')
      expect($('.js-nation-button').attr('aria-label')).toEqual('Remove England and Wales as your saved location for bank holidays')
      expect($('.js-nation-link')[0].style.display).toEqual('none')
    })
  })

  describe('with multiple bank holiday locations', function () {
    var englandAndWales
    var northernIreland

    beforeEach(function () {
      var html = '<div>' +
      '<section class="js-save-nation" data-module="save-bank-holiday-nation" data-nation="England_and_Wales" data-nation-matches=\'["England","Wales"]\' data-save-description="Do you want to save # as your location for bank holidays?" data-save-button-aria-label="Save # as your location for bank holidays" data-save-button-text="Save" data-undo-description="You\'ve saved # as your location for bank holidays" data-undo-button-aria-label="Remove # as your saved location for bank holidays" data-undo-button-text="Undo">' +
        '<p class="js-nation-description" aria-live="polite">Do you want to save # as your location for bank holidays?</p>' +
        '<button id="en" class="js-nation-button" type="submit" aria-label="Save # as your location for bank holidays">Save</button>' +
        '<p class="js-nation-link">' +
          '<a href="#" class="govuk-link">We\'ll add a cookie to your device</a>' +
        '</p>' +
      '</section>' +
      '<section class="js-save-nation" data-module="save-bank-holiday-nation" data-nation="Northern_Ireland" data-nation-matches=\'["Northern Ireland"]\' data-save-description="Do you want to save # as your location for bank holidays?" data-save-button-aria-label="Save # as your location for bank holidays" data-save-button-text="Save" data-undo-description="You\'ve saved # as your location for bank holidays" data-undo-button-aria-label="Remove # as your saved location for bank holidays" data-undo-button-text="Undo">' +
        '<p class="js-nation-description" aria-live="polite">Do you want to save # as your location for bank holidays?</p>' +
        '<button id="ni" class="js-nation-button" type="submit" aria-label="Save # as your location for bank holidays">Save</button>' +
        '<p class="js-nation-link">' +
          '<a href="#" class="govuk-link">We\'ll add a cookie to your device</a>' +
        '</p>' +
      '</section>' +
      '</div>'
      $locations = $(html)

      $('body').append($locations)
      window.GOVUK.setCookie('user_nation', 'Northern_Ireland')
      $locations.find('.js-save-nation').each(function () {
        var bank = new GOVUK.Modules.SaveBankHolidayNation()
        bank.start($(this))
      })
      englandAndWales = $('[data-nation=England_and_Wales]')
      northernIreland = $('[data-nation=Northern_Ireland]')
    })

    it('sets the state correctly', function () {
      expect(englandAndWales.find('.js-nation-description').text()).toEqual('Do you want to save England and Wales as your location for bank holidays?')
      expect(englandAndWales.find('.js-nation-button').text()).toEqual('Save')
      expect(englandAndWales.find('.js-nation-button').attr('aria-label')).toEqual('Save England and Wales as your location for bank holidays')
      expect(englandAndWales.find('.js-nation-link')[0].style.display).toEqual('block')

      expect(northernIreland.find('.js-nation-description').text()).toEqual('You\'ve saved Northern Ireland as your location for bank holidays')
      expect(northernIreland.find('.js-nation-button').text()).toEqual('Undo')
      expect(northernIreland.find('.js-nation-button').attr('aria-label')).toEqual('Remove Northern Ireland as your saved location for bank holidays')
      expect(northernIreland.find('.js-nation-link')[0].style.display).toEqual('none')
    })

    it('updates the state correctly after clicking', function () {
      $locations.find('#en').click()

      expect(englandAndWales.find('.js-nation-description').text()).toEqual('You\'ve saved England and Wales as your location for bank holidays')
      expect(englandAndWales.find('.js-nation-button').text()).toEqual('Undo')
      expect(englandAndWales.find('.js-nation-button').attr('aria-label')).toEqual('Remove England and Wales as your saved location for bank holidays')
      expect(englandAndWales.find('.js-nation-link')[0].style.display).toEqual('none')

      expect(northernIreland.find('.js-nation-description').text()).toEqual('Do you want to save Northern Ireland as your location for bank holidays?')
      expect(northernIreland.find('.js-nation-button').text()).toEqual('Save')
      expect(northernIreland.find('.js-nation-button').attr('aria-label')).toEqual('Save Northern Ireland as your location for bank holidays')
      expect(northernIreland.find('.js-nation-link')[0].style.display).toEqual('block')
    })
  })

  describe('with URL fragments', function () {
    it('appends the right URL fragment if no fragment is present', function () {
      window.GOVUK.setCookie('user_nation', 'England_and_Wales')
      $locations = $(html)
      $('body').append($locations)
      var bank = new GOVUK.Modules.SaveBankHolidayNation()
      bank.start($locations)

      expect(window.location.hash).toEqual('#england-and-wales')
    })

    it('doesn\'t append a URL fragment if one is already present', function () {
      window.GOVUK.setCookie('user_nation', 'scotland')
      $locations = $(html)
      $('body').append($locations)
      window.location.hash = '#england-and-wales'
      var bank = new GOVUK.Modules.SaveBankHolidayNation()
      bank.start($locations)

      expect(window.location.hash).toEqual('#england-and-wales')
    })
  })

  it('appends the correct URL fragment when the nation cookie partially matches one of the tabs', function () {
    window.GOVUK.setCookie('user_nation', 'England')
    $locations = $(html)
    $('body').append($locations)
    var bank = new GOVUK.Modules.SaveBankHolidayNation()
    bank.start($locations)
    var englandAndWales = $('[data-nation=England_and_Wales]')

    expect(window.location.hash).toEqual('#england-and-wales')
    expect(englandAndWales.find('.js-nation-description').text()).toEqual('Do you want to save England and Wales as your location for bank holidays?')
  })

  it('does not append a URL fragment when the cookie does not match one of the nations', function () {
    window.GOVUK.setCookie('user_nation', 'spooky cookie')
    $locations = $(html)
    $('body').append($locations)
    var bank = new GOVUK.Modules.SaveBankHolidayNation()
    bank.start($locations)

    expect(window.location.hash).toEqual('')
  })
})
