describe('A utm campaign module', function () {
  let module
  let element
  const href = 'https://www.example.com/next-page'

  function init (elementType, linkHref) {
    elementType = elementType || 'a'
    element = document.createElement(elementType)
    linkHref = linkHref || href
    element.setAttribute('href', linkHref)
    document.body.appendChild(element)
    module = new window.GOVUK.Modules.UrlParams(element)
    module.init()
  }

  function setUrlParams (value) {
    value = value || 'test'
    const url = new URL(window.location.href)
    url.searchParams.set('utm_campaign', value)
    window.history.replaceState({}, '', url)
  }

  function removeUrlParams () {
    const url = new URL(window.location.href)
    url.searchParams.delete('utm_campaign')
    window.history.replaceState({}, '', url)
  }

  afterEach(function () {
    removeUrlParams()
    document.body.removeChild(element)
  })

  it('basically works', function () {
    setUrlParams()
    init()
    expect(element.getAttribute('href')).toBe('https://www.example.com/next-page?utm_campaign=test')
  })

  it('does not modify the href when there is no utm_campaign parameter', function () {
    init()
    expect(element.getAttribute('href')).toBe(href)
  })

  it('does not modify the element when the element is not a link', function () {
    setUrlParams()
    init('div')
    expect(element.getAttribute('href')).toBe(href)
  })

  it('preserves any existing query parameters on the link', function () {
    setUrlParams()
    init('a', `${href}?foo=bar`)
    expect(element.getAttribute('href')).toBe('https://www.example.com/next-page?foo=bar&utm_campaign=test')
  })

  it('preserves existing fragments on the link', function () {
    setUrlParams()
    init('a', `${href}#section`)
    expect(element.getAttribute('href')).toBe('https://www.example.com/next-page?utm_campaign=test#section')
  })

  it('preserves existing fragments and query parameters on the link', function () {
    setUrlParams()
    init('a', `${href}?foo=bar#section`)
    expect(element.getAttribute('href')).toBe('https://www.example.com/next-page?foo=bar&utm_campaign=test#section')
  })

  it('replaces an existing utm_campaign parameter', function () {
    setUrlParams()
    init('a', `${href}?utm_campaign=shouldnotbethis`)
    expect(element.getAttribute('href')).toBe('https://www.example.com/next-page?utm_campaign=test')
  })

  it('encodes characters in the URL when putting them on the link', function () {
    setUrlParams('<test>;')
    init()
    expect(element.getAttribute('href')).toBe('https://www.example.com/next-page?utm_campaign=%3Ctest%3E%3B')
  })
})
