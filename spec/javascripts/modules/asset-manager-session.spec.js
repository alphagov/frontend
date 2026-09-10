describe('An asset manager session module', function () {
  let element, originalImage

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

  beforeEach(function () {
    originalImage = window.Image
    element = document.createElement('div')
    element.setAttribute('data-module', 'AssetManagerSession')
    element.setAttribute(
      'data-placeholder-asset-url',
      'https://draft-assets.test.gov.uk/media/placeholder/placeholder.jpg'
    )
  })

  afterEach(function () {
    window.Image = originalImage
    document.querySelectorAll('img').forEach((img) => img.remove())
  })

  it('does nothing when fewer than two draft images are on the page', function () {
    addImage('https://draft-assets.test.gov.uk/media/1/one.jpg')
    stubImage({ succeeds: true })

    new GOVUK.Modules.AssetManagerSession(element).warmUpSession()

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

    new GOVUK.Modules.AssetManagerSession(element).warmUpSession()

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

    new GOVUK.Modules.AssetManagerSession(element).warmUpSession()

    expect(firstReloads).toEqual([
      'https://draft-assets.test.gov.uk/media/1/one.jpg'
    ])
  })

  it('ignores non-asset-manager images when counting/retrying', function () {
    const other = addImage('https://static.test.gov.uk/media/1/one.jpg')
    addImage('https://draft-assets.test.gov.uk/media/2/two.jpg')
    stubImage({ succeeds: true })

    new GOVUK.Modules.AssetManagerSession(element).warmUpSession()

    expect(other.src).toEqual('https://static.test.gov.uk/media/1/one.jpg')
  })
})
