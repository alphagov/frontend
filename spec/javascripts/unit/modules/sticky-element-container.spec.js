describe('A sticky-element-container module', function () {
  'use strict'

  var GOVUK = window.GOVUK

  describe('on desktop', function () {
    var element
    var footer
    var instance

    beforeEach(function () {
      element = document.createElement('div')
      element.dataset.module = 'sticky-element-container'
      element.style.cssText = 'height: 9001px; margin-bottom: 1000px'
      element.innerHTML = `
        <div data-sticky-element>
          <span>Content</span>
        </div>
      `

      instance = new GOVUK.Modules.StickyElementContainer(element)
      footer = element.querySelector('[data-sticky-element]')

      instance.getWindowDimensions = function () {
        return {
          height: 768,
          width: 1024
        }
      }
    })

    it('hides the element, when scrolled at the top', function () {
      instance.getWindowPositions = function () {
        return {
          scrollTop: 0
        }
      }

      instance.checkResize()
      instance.checkScroll()

      expect(footer).toHaveClass('sticky-element--hidden')
      expect(footer).toHaveClass('sticky-element--stuck-to-window')
    })

    it('shows the element, stuck to the window, when scrolled in the middle', function () {
      instance.getWindowPositions = function () {
        return {
          scrollTop: 5000
        }
      }

      instance.checkResize()
      instance.checkScroll()

      expect(footer).not.toHaveClass('sticky-element--hidden')
      expect(footer).toHaveClass('sticky-element--stuck-to-window')
    })

    it('shows the element, stuck to the parent, when scrolled at the bottom', function () {
      instance.getWindowPositions = function () {
        return {
          scrollTop: 9800
        }
      }

      instance.checkResize()
      instance.checkScroll()

      expect(footer).not.toHaveClass('sticky-element--hidden')
      expect(footer).not.toHaveClass('sticky-element--stuck-to-window')
    })
  })
})
