describe('CheckboxFilter', function(){
  var filterHTML, filter;

  beforeEach(function(){
    filter = "<div class='filter checkbox-filter js-openable-filter closed' tabindex='0'>" +
  "<div class='head'>" +
    "<span class='legend'>Organisation</span>" +
    "<div class='controls'>" +
      "<a class='clear-selected js-hidden'>clear</a>" +
      "<div class='toggle'></div>" +
    "</div>" +
  "</div>" +
  "<div class='checkbox-container' id='organisations-filter'>" +
    "<ul>" +
      "<li>" +
        "<input type='checkbox' name='filter_organisations[]' value='department-for-business-innovation-skills' id='department-for-business-innovation-skills'>" +
        "<label for='department-for-business-innovation-skills'> Department for Business, Innovation &amp; Skills (956)" +
        "</label>" +
      "</li>" +
      "<li>" +
        "<input type='checkbox' name='filter_organisations[]' value='hm-revenue-customs' id='hm-revenue-customs'>" +
        "<label for='hm-revenue-customs'> HM Revenue &amp; Customs (727)" +
        "</label>" +
      "</li>" +
    "</ul>" +
  "</div>" +
"</div>";

    filterHTML = $(filter);
    $('body').append(filterHTML);
    filter = new GOVUK.CheckboxFilter({el:filterHTML});

  });

  afterEach(function(){
    filterHTML.remove();
  });

  it('should check the open status of the checkbox when it creates the facet', function(){
    spyOn(GOVUK.CheckboxFilter.prototype, 'isOpen').andReturn(true);
    spyOn(GOVUK.CheckboxFilter.prototype, 'setupHeight');

    filter = new GOVUK.CheckboxFilter({el:filterHTML});

    expect(filter.setupHeight.calls.length).toBe(1);
  });

  describe('open', function(){

    it('should remove the class closed to the facet', function(){
      filterHTML.addClass('closed');
      expect(filterHTML.hasClass('closed')).toBe(true);
      filter.open();
      expect(filterHTML.hasClass('closed')).toBe(false);
    });

    it ('should call setupHeight', function(){
      filterHTML.addClass('closed');
      spyOn(filter, "setupHeight");
      filter.open();
      expect(filter.setupHeight.calls.length).toBe(1);
    });

  });

  describe('close', function(){

    it('should remove the class closed from the facet', function(){
      filterHTML.removeClass('closed');
      expect(filterHTML.hasClass('closed')).toBe(false);
      filter.close();
      expect(filterHTML.hasClass('closed')).toBe(true);
    });

  });

  describe ('setupHeight', function(){
    var checkboxContainerHeight, stretchMargin;

    beforeEach(function(){

      // Set the height of check-box container to 200 (this is done in the CSS IRL)
      checkboxContainerHeight = 200;
      stretchMargin = 50;
      filterHTML.find('.checkbox-container').height(checkboxContainerHeight);

    });

    it('should shrink checkbox-container to fit the checkbox list if the list is smaller than the container', function(){
      var listHeight = filterHTML.find('.checkbox-container > ul').height();

      filter.setupHeight();

      expect(filterHTML.find('.checkbox-container').height()).toBe(listHeight);
    });

    it('should expand checkbox-container to fit checkbox list if the list is < 50px larger than the container', function(){
      // build a list that is just bigger than the parent height which will be 200px
      listItem = "<li><input type='checkbox' name='filter_organisations[]'id='department-for-business-innovation-skills'><label for='department-for-business-innovation-skills'> Department for Business, Innovation &amp; Skills (956)</label></li>";

      while( filterHTML.find('.checkbox-container > ul').height() < checkboxContainerHeight) {
        filterHTML.find('.checkbox-container > ul').append(listItem);
      }

      filter.setupHeight();

      var listHeight = filterHTML.find('.checkbox-container > ul').height();

      expect(filterHTML.find('.checkbox-container').height()).toBe(listHeight);
    });

    it('should do nothing if the height of the checkbox container height is smaller than the checkbox list by more than 50px', function(){
      // build a list whose height is bigger than the parent height + stretch margin
      listItem = "<li><input type='checkbox' name='filter_organisations[]'id='department-for-business-innovation-skills'><label for='department-for-business-innovation-skills'> Department for Business, Innovation &amp; Skills (956)</label></li>";

      while( filterHTML.find('.checkbox-container > ul').height() < stretchMargin + checkboxContainerHeight + 1) {
        filterHTML.find('.checkbox-container > ul').append(listItem);
      }

      filter.setupHeight();

      var listHeight = filterHTML.find('.checkbox-container > ul').height();

      expect(filterHTML.find('.checkbox-container').height()).toBe(checkboxContainerHeight);
    });

  });

  describe('listenForKeys', function(){

    it('should bind an event handler to the keypress event', function(){
      spyOn(filter, "checkForSpecialKeys");
      filter.listenForKeys();

      // Simulate keypress
      filterHTML.trigger('keypress');
      expect(filter.checkForSpecialKeys.calls.length).toBe(1);
    });

  });

  describe('checkForSpecialKeys', function(){

    it ("should do something if the key event passed in is a return character", function(){
      spyOn(filter, "toggleFinder");
      filter.listenForKeys();

      // 13 is the return key
      filter.checkForSpecialKeys({keyCode:13});

      expect(filter.toggleFinder.calls.length).toBe(1);
    });

    it ('should do nothing if the key is not return', function(){
      spyOn(filter, "toggleFinder");
      filter.listenForKeys();

      filter.checkForSpecialKeys({keyCode:11});
      expect(filter.toggleFinder.calls.length).toBe(0);
    });

  });

  describe('stopListeningForKeys', function(){

    it('should remove an event handler for the keypress event', function(){
      spyOn(filter, "checkForSpecialKeys");
      filter.listenForKeys();
      filter.stopListeningForKeys();
      // Simulate keypress
      filterHTML.trigger('keypress');
      expect(filter.checkForSpecialKeys.calls.length).toBe(0);
    });

  });

  describe('ensureFinderIsOpen', function(){
    it ('should always leave the facet in an open state', function(){
      filterHTML.addClass('closed')
      expect(filterHTML.hasClass('closed')).toBe(true);

      filter.ensureFinderIsOpen();
      expect(filterHTML.hasClass('closed')).toBe(false);
      filter.ensureFinderIsOpen();
      expect(filterHTML.hasClass('closed')).toBe(false);

    });
  });

  describe('toggleFinder', function(){

    it("should call close if the facet is currently open", function(){
      filterHTML.removeClass('closed');
      spyOn(filter, "close");
      filter.toggleFinder();
      expect(filter.close.calls.length).toBe(1);
    });

    it("should call open if the facet is currently closed", function(){
      filterHTML.addClass('closed');
      spyOn(filter, "open");
      filter.toggleFinder();
      expect(filter.open.calls.length).toBe(1);
    });

  });

  describe('resetCheckboxes', function(){

    it("should uncheck any checked checkboxes", function(){

      // Check all checkboxes on this filter
      filterHTML.find('.checkbox-container input').prop("checked", true);
      expect(filterHTML.find(':checked').length).toBe($('.checkbox-container input').length);

      // Reset them
      filter.resetCheckboxes();

      // They should not be checked
      expect(filterHTML.find(':checked').length).toBe(0);
    });

  });

  describe("updateCheckboxResetter", function(){

    it("should add the visually-hidden class to the checkbox resetter if no checkboxes are checked",function(){

      expect(filterHTML.find($('.clear-selected')).hasClass('js-hidden')).toBe(true);
      filter.updateCheckboxResetter();
      expect(filterHTML.find($('.clear-selected')).hasClass('js-hidden')).toBe(true);

      $('#department-for-business-innovation-skills').prop("checked", true);
      filter.updateCheckboxResetter();
      expect(filterHTML.find($('.clear-selected')).hasClass('js-hidden')).toBe(false);
    });

    it("should remove the visually-hidden class to the checkbox resetter if any checkboxes are checked",function(){

       filterHTML.find($('.clear-selected')).removeClass('js-hidden');
       expect(filterHTML.find($('.clear-selected')).hasClass('js-hidden')).toBe(false);

       filter.updateCheckboxResetter();
       expect(filterHTML.find($('.clear-selected')).hasClass('js-hidden')).toBe(true);
    });

  });

});

