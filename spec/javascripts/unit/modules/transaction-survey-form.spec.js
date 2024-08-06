describe('Transaction survey form module', function () {
  'use strict'

  it('adds additional inputs to the form', function () {
    var form = document.createElement('form')
    var module = new GOVUK.Modules.TransactionSurveyForm(form)
    module.init()

    var jsInput = form.querySelector('input[type=hidden][name="service_feedback[javascript_enabled]"][value=true]')
    expect(jsInput).not.toBeNull()

    var referrerInput = form.querySelector('input[type=hidden][name="referrer"]')
    expect(referrerInput).not.toBeNull()
  })

  it('disables a submit button after the form is submit', function () {
    var form = document.createElement('form')
    form.innerHTML = '<button type="submit">Submit</button>'
    document.body.appendChild(form)

    var module = new GOVUK.Modules.TransactionSurveyForm(form)
    module.init()

    // prevent submit causing navigation
    form.addEventListener('submit', function (e) { e.preventDefault() })

    var button = form.querySelector('button')
    button.click()

    expect(button.disabled).toBeTrue()

    document.body.removeChild(form)
  })

  it('does not throw an error if the button does not exist', function () {
    var form = document.createElement('form')
    document.body.appendChild(form)

    var module = new GOVUK.Modules.TransactionSurveyForm(form)
    module.init()

    // prevent submit causing navigation
    form.addEventListener('submit', function (e) { e.preventDefault() })

    form.requestSubmit()

    document.body.removeChild(form)
  })
})
