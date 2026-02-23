describe('A hide-other-links module', function () {
  var list = document.createElement('dd')
  var GOVUK = window.GOVUK

  function subject () {
    document.body.appendChild(list)
    var instance = new GOVUK.Modules.HideOtherLinks(list)
    instance.init()
  }

  afterEach(function () {
    list.remove()
  })

  describe('with a list of more than 2 links', function () {
    beforeEach(function () {
      list.classList.add('animals')
      list.setAttribute('data-hide-other-links-link-text', 'Show 3 more ')
      list.setAttribute('data-hide-other-links-visually-hidden-link-text', 'worldwide location news')
      list.innerHTML = `
        <a href="http://en.wikipedia.org/wiki/dog">Dog</a>, 
        <a href="http://en.wikipedia.org/wiki/cat">Cat</a>, 
        <a href="http://en.wikipedia.org/wiki/cow">Cow</a> and 
        <a href="http://en.wikipedia.org/wiki/pig">Pig</a>.
      `
      subject()
    })

    it('groups elements into other-content span', function () {
      expect(list.querySelector('.other-content').childElementCount).toBe(3)
    })

    it('creates a link to show hidden content', function () {
      expect(list.querySelector('.show-other-content')).not.toBeNull()
    })

    it('renders the text from data-hide-other-links-link-text in the link', function () {
      expect(list.querySelector('.show-other-content').textContent).toBe('Show 3 more worldwide location news')
    })

    it('has the correct visually hidden text in the link', function () {
      expect(list.querySelector('.show-other-content .govuk-visually-hidden').textContent).toBe('worldwide location news')
    })

    it('sets the correct aria value', function () {
      expect(list.getAttribute('aria-live')).toEqual('polite')
    })
  })

  describe('with a list of 2 short links', function () {
    beforeEach(function () {
      list.classList.add('animals')
      list.innerHTML = `
        <a href="http://en.wikipedia.org/wiki/dog">Dog</a>, 
        <a href="http://en.wikipedia.org/wiki/cat">Cat</a>, 
      `

      subject()
    })

    it('does not hide any links', function () {
      expect(list.querySelector('.other-content')).toBeNull()
    })
  })

  describe('with a list of 2 long links', function () {
    beforeEach(function () {
      list.classList.add('long-words')
      list.innerHTML = `
        <a href="http://en.wikipedia.org/wiki/Lopado­temacho­selacho­galeo­kranio­leipsano­drim­hypo­trimmato­silphio­parao­melito­katakechy­meno­kichl­epi­kossypho­phatto­perister­alektryon­opte­kephallio­kigklo­peleio­lagoio­siraio­baphe­tragano­pterygon">Lopado­temacho­selacho­galeo­kranio­leipsano­drim­hypo­trimmato­silphio­parao­melito­katakechy­meno­kichl­epi­kossypho­phatto­perister­alektryon­opte­kephallio­kigklo­peleio­lagoio­siraio­baphe­tragano­pterygon</a>,
        <a href="http://en.wikipedia.org/wiki/Pneumonoultramicroscopicsilicovolcanoconiosis">Pneumonoultramicroscopicsilicovolcanoconiosis</a>,
      `

      subject()
    })

    it('hides the links', function () {
      expect(list.querySelector('.long-words .other-content').childElementCount).toBe(1)
    })
  })

  describe('with a list without data-hide-other-links-link-text attribute', function () {
    beforeEach(function () {
      list.classList.add('animals-without-text-attribute')
      list.setAttribute('data-hide-other-links-visually-hidden-link-text', 'worldwide location news')
      list.innerHTML = `
        <a href="http://en.wikipedia.org/wiki/dog">Dog</a>, 
        <a href="http://en.wikipedia.org/wiki/cat">Cat</a>, 
        <a href="http://en.wikipedia.org/wiki/cow">Cow</a> and 
        <a href="http://en.wikipedia.org/wiki/pig">Pig</a>.
      `
      subject()
    })

    it('the show link does not appear', function () {
      expect(list.querySelector('.animals-without-text-attribute .show-other-content')).toBeNull()
    })
  })
})
