// This isn't a GOVUK.Modules-style module - it's a plain script, self-
// executing on load - so rather than constructing a fresh instance of
// something per test, each test here re-injects the actual source file as
// a fresh <script> tag, exactly as the footer partial does in production,
// and drives it via a synthetic 'load' event.
describe('The asset manager session script', function () {
  const SCRIPT_SRC = '/__src__/app/assets/javascripts/asset-manager-session.js'
  const PLACEHOLDER_URL = 'https://draft-assets.test.gov.uk/media/placeholder/placeholder.jpg'

  let scriptElement, originalImage

  const addImage = (src) => {
    const img = document.createElement('img')
    img.src = src
    document.body.appendChild(img)
    return img
  }

  const trackReloads = (image) => {
    const reloadedUrls = []
    const originalSetAttribute = image.setAttribute.bind(image)
    image.setAttribute = (name, value) => {
      if (name === 'src') reloadedUrls.push(value)
      originalSetAttribute(name, value)
    }
    return reloadedUrls
  }

  const stubImage = ({ succeeds }) => {
    class FakeImage {
      get src () {
        return this._src
      }

      set src (value) {
        this._src = value
        succeeds
          ? this.onload && this.onload()
          : this.onerror && this.onerror()
      }
    }
    window.Image = FakeImage
  }

  beforeEach(function (done) {
    originalImage = window.Image

    // A fresh <script> element each time, matching how the footer partial
    // inlines this file in production - so this test suite is exercising
    // the real file on disk, not a copy of its behaviour.
    scriptElement = document.createElement('script')
    scriptElement.setAttribute('data-placeholder-asset-url', PLACEHOLDER_URL)
    scriptElement.addEventListener('load', () => done())
    scriptElement.src = SCRIPT_SRC
    document.body.appendChild(scriptElement)
  })

  afterEach(function () {
    window.Image = originalImage
    scriptElement.remove()
    document.querySelectorAll('img').forEach((img) => img.remove())
  })

  it('does nothing when fewer than two draft images are on the page', function () {
    addImage('https://draft-assets.test.gov.uk/media/1/one.jpg')
    stubImage({ succeeds: true })

    window.dispatchEvent(new Event('load'))

    expect(document.images[0].src).toEqual(
      'https://draft-assets.test.gov.uk/media/1/one.jpg'
    )
  })

  it('retries all draft images once the placeholder request succeeds', function () {
    const first = addImage('https://draft-assets.test.gov.uk/media/1/one.jpg')
    const second = addImage(
      'https://draft-assets.test.gov.uk/media/2/two.jpg?foo=bar'
    )
    const firstReloads = trackReloads(first)
    const secondReloads = trackReloads(second)
    stubImage({ succeeds: true })

    window.dispatchEvent(new Event('load'))

    expect(firstReloads).toEqual([
      'https://draft-assets.test.gov.uk/media/1/one.jpg'
    ])
    expect(secondReloads).toEqual([
      'https://draft-assets.test.gov.uk/media/2/two.jpg?foo=bar'
    ])
  })

  it('also retries all draft images when the placeholder request errors', function () {
    const first = addImage('https://draft-assets.test.gov.uk/media/1/one.jpg')
    addImage('https://draft-assets.test.gov.uk/media/2/two.jpg')
    const firstReloads = trackReloads(first)
    stubImage({ succeeds: false })

    window.dispatchEvent(new Event('load'))

    expect(firstReloads).toEqual([
      'https://draft-assets.test.gov.uk/media/1/one.jpg'
    ])
  })

  it('ignores non-asset-manager images when counting/retrying', function () {
    const other = addImage('https://static.test.gov.uk/media/1/one.jpg')
    addImage('https://draft-assets.test.gov.uk/media/2/two.jpg')
    stubImage({ succeeds: true })

    window.dispatchEvent(new Event('load'))

    expect(other.src).toEqual('https://static.test.gov.uk/media/1/one.jpg')
  })

  it('reads the placeholder asset URL from its own <script> tag, ignoring any other element on the page', function () {
    const decoy = document.createElement('div')
    decoy.setAttribute('data-placeholder-asset-url', 'https://evil.example.com/not-this-one.jpg')
    document.body.appendChild(decoy)
    addImage('https://draft-assets.test.gov.uk/media/1/one.jpg')
    addImage('https://draft-assets.test.gov.uk/media/2/two.jpg')
    const requestedUrls = []
    class FakeImage {
      set src (value) {
        requestedUrls.push(value)
        this.onload && this.onload()
      }
    }
    window.Image = FakeImage

    window.dispatchEvent(new Event('load'))

    expect(requestedUrls).toEqual([PLACEHOLDER_URL])
    decoy.remove()
  })

  it('only responds to a single load event per script execution', function () {
    addImage('https://draft-assets.test.gov.uk/media/1/one.jpg')
    const second = addImage('https://draft-assets.test.gov.uk/media/2/two.jpg')
    const secondReloads = trackReloads(second)
    stubImage({ succeeds: true })

    window.dispatchEvent(new Event('load'))
    window.dispatchEvent(new Event('load'))

    expect(secondReloads.length).toEqual(1)
  })
})
