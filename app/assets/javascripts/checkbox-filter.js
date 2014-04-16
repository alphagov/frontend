(function() {
  "use strict";

  window.GOVUK = window.GOVUK || {};

  function CheckboxFilter(options){
    var allowCollapsible = (typeof ieVersion == "undefined" || ieVersion > 7) ? true : false;

    this.$filter = options.el;
    this.$checkboxResetter = this.$filter.find('.clear-selected');
    this.$checkboxes = this.$filter.find("input[type='checkbox']");

    this.$checkboxResetter.on('click', $.proxy(this.resetCheckboxes, this));

    this.$checkboxes.on('click', $.proxy(this.updateCheckboxes, this));
    this.$checkboxes.on('focus', $.proxy(this.ensureFinderIsOpen, this));

    // setupHeight is called on open, but filters containing checked checkboxes will already be open
    if (this.isOpen() || !allowCollapsible) {
      this.setupHeight();
    }

    if(allowCollapsible){
      // set up open/close listeners
      this.$filter.find('.head').on('click', $.proxy(this.toggleFinder, this));
      this.$filter.on('focus', $.proxy(this.listenForKeys, this));
      this.$filter.on('blur', $.proxy(this.stopListeningForKeys, this));
    }

  }

  CheckboxFilter.prototype.setupHeight = function setupHeight(){
    var checkboxContainer = this.$filter.find('.checkbox-container');
    var checkboxList = checkboxContainer.children('ul');
    var initCheckboxContainerHeight = checkboxContainer.height();
    var height = checkboxList.height();

    if (height < initCheckboxContainerHeight) {
      // Resize if the list is smaller than its container
      checkboxContainer.height(height);

    } else if (checkboxList.height() < initCheckboxContainerHeight + 50) {
      // Resize if the list is only slightly bigger than its container
      checkboxContainer.height(checkboxList.height());
    }
  }

  CheckboxFilter.prototype.isOpen = function isOpen(){
    return !this.$filter.hasClass('closed');
  }

  CheckboxFilter.prototype.open = function open(){
    this.$filter.removeClass('closed');
    this.setupHeight();
  };

  CheckboxFilter.prototype.close = function close(){
    this.$filter.addClass('closed');
  };

  CheckboxFilter.prototype.listenForKeys = function listenForKeys(){
    this.$filter.keypress($.proxy(this.checkForSpecialKeys, this));
  };

  CheckboxFilter.prototype.checkForSpecialKeys = function checkForSpecialKeys(e){
    if(e.keyCode == 13) {

      // keyCode 13 is the return key.
      this.toggleFinder();
    }
  };

  CheckboxFilter.prototype.stopListeningForKeys = function stopListeningForKeys(){
    this.$filter.unbind('keypress');
  };

  CheckboxFilter.prototype.ensureFinderIsOpen = function ensureFinderIsOpen(){
    if (this.$filter.hasClass('closed')) {
      this.open();
    }
  };

  CheckboxFilter.prototype.toggleFinder = function toggleFinder(){
    if (this.$filter.hasClass('closed')) {
      this.open();
    } else {
      this.close();
    }
  };

  CheckboxFilter.prototype.resetCheckboxes = function resetCheckboxes(){
    this.$filter.find("input[type='checkbox']").prop({
      indeterminate: false,
      "checked": false
    });
    this.$checkboxResetter.addClass('js-hidden');
    return false;
  };

  CheckboxFilter.prototype.updateCheckboxes = function updateCheckboxes(e){
    // Nested checkboxes affect their ancestors and children
    var checked = $(e.target).prop("checked"),
        container = $(e.target).parent(),
        siblings = container.siblings();

    // Set all children of this checkbox to match this checkbox
    container.find('input[type="checkbox"]').prop({
      indeterminate: false,
      checked: checked
    });

    this.checkSiblings(container, checked);
    this.updateCheckboxResetter();

  };

  CheckboxFilter.prototype.checkSiblings = function checkSiblings(listitem, checked){
    var parent = listitem.parent().parent(),
        all = true;

    // Do all the checkboxes on this level agree?
    listitem.siblings().each(function(){
      return all = ($(this).children('input[type="checkbox"]').prop("checked") === checked);
    });

    if (all) {
      /*
        If all the checkboxes on this level agree set their shared parent to be the same.
        Then push the changes up the checkbox tree.
      */
      parent.children('input[type="checkbox"]').prop({
        indeterminate: false,
        checked: checked
      });
      this.checkSiblings(parent, all);

    } else {
       // if the checkboxes on this level disagree then set the parent to indeterminate
       listitem.parents('li').children('input[type="checkbox"]').prop({
         indeterminate: true,
         checked: false
       });
     }
   }

  CheckboxFilter.prototype.updateCheckboxResetter = function updateCheckboxResetter(){
    var anyCheckedBoxes = this.$checkboxes.is(":checked"),
        checkboxResetterHidden = this.$checkboxResetter.hasClass('js-hidden');

    if (anyCheckedBoxes && checkboxResetterHidden) {
      this.$checkboxResetter.removeClass('js-hidden');
    } else if (!anyCheckedBoxes && !checkboxResetterHidden) {
      this.$checkboxResetter.addClass('js-hidden');
    }
  };

  GOVUK.CheckboxFilter = CheckboxFilter;
}());
