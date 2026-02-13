describe('A hide-other-links module', function () {
  var list
  var GOVUK = window.GOVUK

  function subject () {
    $('body').append(list)
    var instance = new GOVUK.Modules.HideOtherLinks(list[0])
    instance.init()
  }

  afterEach(function () {
    list.remove()
  })

  describe('with a list of 1 short link', function () {
    beforeEach(function () {
      list = $(
        '<dd class="single-link">' +
          '<a href="/dog">Dog</a>' +
        '</dd>'
      )

      subject()
    })

    it('does not create other-content container', function () {
      expect($('.single-link .other-content').length).toBe(0)
    })
  })

  describe('with a list of more than 2 links', function () {
    beforeEach(function () {
      list = $(
        '<dd class="animals" data-hide-other-links-text="Show 3 more <span class="govuk-visually-hidden">worldwide location news</span>"' +
          '<a class="govuk-link" href="http://en.wikipedia.org/wiki/dog">Dog</a>, ' +
          '<a class="govuk-link" href="http://en.wikipedia.org/wiki/cat">Cat</a>, ' +
          '<a class="govuk-link" href="http://en.wikipedia.org/wiki/cow">Cow</a> and ' +
          '<a class="govuk-link" href="http://en.wikipedia.org/wiki/pig">Pig</a>.' +
        '</dd>'
      )

      subject()
    })

    it('makes the first item visible', function () {
      var element = document.querySelector('.animals')
      expect(element.firstElementChild.textContent).toContain('Dog')
    })

    it('groups elements into other-content span', function () {
      expect($('.animals .other-content').children().length).toBe(3)
    })

    it('creates a link to show hidden content', function () {
      expect($('.animals .show-other-content').length).toBe(1)
    })

    it('has the correct count in the link', function () {
      var otherCount = $('.animals .other-content').find('.govuk-link').length
      var linkCount = $('.animals .show-other-content').text().match(/\d+/).pop()
      expect(parseInt(linkCount, 10)).toBe(otherCount)
    })

    it('sets the correct aria value', function () {
      expect($('.animals').attr('aria-live')).toEqual('polite')
    })

    it('tests click behaviour', function () {
      var btn = document.querySelector('.show-other-content')
      btn.click()

      expect(document.querySelector('.show-other-content')).toBeNull()
      expect(document.querySelector('.other-content').style.display).toBe('')
      expect(document.activeElement).toBe(document.querySelector('.other-content').firstElementChild)
    })
  })

  describe('with a list of 2 short links', function () {
    beforeEach(function () {
      list = $(
        '<dd class="animals">' +
          '<a href="http://en.wikipedia.org/wiki/dog">Dog</a>, ' +
          '<a href="http://en.wikipedia.org/wiki/cat">Cat</a>, ' +
        '</dd>'
      )

      subject()
    })

    it('does not hide any links', function () {
      expect($('.animals .other-content').length).toBe(0)
    })

    it('does not set aria-live when nothing is hidden', function () {
      expect($('.animals').attr('aria-live')).toBeUndefined()
    })
  })

  describe('with a list of 2 long links', function () {
    beforeEach(function () {
      list = $(
        '<dd class="long-words">' +
          '<a href="http://en.wikipedia.org/wiki/Lopado­temacho­selacho­galeo­kranio­leipsano­drim­hypo­trimmato­silphio­parao­melito­katakechy­meno­kichl­epi­kossypho­phatto­perister­alektryon­opte­kephallio­kigklo­peleio­lagoio­siraio­baphe­tragano­pterygon">Lopado­temacho­selacho­galeo­kranio­leipsano­drim­hypo­trimmato­silphio­parao­melito­katakechy­meno­kichl­epi­kossypho­phatto­perister­alektryon­opte­kephallio­kigklo­peleio­lagoio­siraio­baphe­tragano­pterygon</a>, ' +
          '<a href="http://en.wikipedia.org/wiki/Pneumonoultramicroscopicsilicovolcanoconiosis">Pneumonoultramicroscopicsilicovolcanoconiosis</a>, ' +
        '</dd>'
      )

      subject()
    })

    it('hides the links', function () {
      expect($('.long-words .other-content').children().length).toBe(1)
    })
  })
  
  describe('with 3 child nodes but only 1 link', function () {
    beforeEach(function () {
      list = $(
        '<dd class="one-link-many-text">' +
          '<a href="/dog">Dog</a>' +
          'Some text here. ' +
          '<span>Extra content</span>' +
        '</dd>'
      )

      subject()
    })

    it('does not create other-content container because nothing to hide', function () {
      expect($('.one-link-many-text .other-content').length).toBe(0)
    })
  })
})
