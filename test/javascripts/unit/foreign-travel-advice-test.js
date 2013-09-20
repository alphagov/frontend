// Foreign travel advice tests
describe("CountryFilter", function () {
  describe("Creating an instance", function () {
    var $input,
        filter;
    
    beforeEach(function () {
      $input = $('<input />');
    });

    it("Should require a parameter for its constructor", function () {
      var createAFilterNoParam = function () {
            filter = new GOVUK.countryFilter();
          },
          createAFilterWithParam = function () {
            filter = new GOVUK.countryFilter($input);
          };
    
      expect(createAFilterNoParam).toThrow();
      expect(createAFilterWithParam).not.toThrow();
    });

    it("Should have the correct interface", function () {
      filter = new GOVUK.countryFilter($input);

      expect(filter.filterHeadings).toBeDefined();
      expect(filter.doesSynonymMatch).toBeDefined();
      expect(filter.filterListItems).toBeDefined();
      expect(filter.updateCounter).toBeDefined();
    });

    it("Should have the correct properties applied to it", function () {
      filter = new GOVUK.countryFilter($input);
      
      expect(filter.container).toBeDefined();
    });

    it("Should attach a call to it's filterListItems method in the sent jQuery object's keyup method", function () {
      filter = new GOVUK.countryFilter($input);
      spyOn(filter, "filterListItems");

      $input.keyup();

      expect(filter.filterListItems).toHaveBeenCalled();
    });

    it("Should cancel events bound to keypress when enter is pressed", function () {
      var invalidEventMock = {
            "which": 8,
            "preventDefault": jasmine.createSpy("preventDefault1")
          },
          validEventMock = {
            "which": 13,
            "preventDefault": jasmine.createSpy("preventDefault2")
          },
          callback;

      $input.keypress = function (func) {
        callback = func;
      };
      filter = new GOVUK.countryFilter($input);

      // call event with backspace
      callback(invalidEventMock);
      expect(invalidEventMock.preventDefault).not.toHaveBeenCalled();

      // call event with enter
      callback(validEventMock);
      expect(validEventMock.preventDefault).toHaveBeenCalled();
    });

    it("Should set aria attributes on div.countries-wrapper", function () {
      var $container = $("<div><div class='countries-wrapper' /></div>");
      $input = $("<input />");

      $container.append($input);
      filter = new GOVUK.countryFilter($input);

      
    });
  });
});
