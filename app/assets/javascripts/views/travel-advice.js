(function() {
  "use strict"
  var root = this,
      $ = root.jQuery;

  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  $.expr[':'].contains = function(obj, index, meta){
    return (obj.textContent || obj.innerText || "").toUpperCase().indexOf(meta[3].toUpperCase()) >= 0;
  };

  var countryFilter = function(input) {
    var enterKeyCode = 13,
        filterInst = this;

    input.keyup(function() {
      var filter = $(this).val();

      filterInst.filterListItems(filter);
    }).keypress(function(event) {
      if (event.which == enterKeyCode) {
        event.preventDefault();
      }
    });

    $(".countries-wrapper").attr("aria-live", "polite");
    $(document).bind("countrieslist", this.updateCounter);
  };

  countryFilter.prototype.filterHeadings = function(countryHeadings) {
    var headingHasVisibleCountries = function(headingFirstLetter) {
          return $("#" + headingFirstLetter.toUpperCase()).find("li:visible").length > 0;
        };

    countryHeadings.each(function(index, elem) {
      var $elem = $(elem), header = $elem.text().match(/[A-Z]{1}$/)[0];
      headingHasVisibleCountries(header) ? $elem.show() : $elem.hide();
    });
  };

  countryFilter.prototype.doesSynonymMatch = function(elem, synonym) {
    var synonyms = $(elem).data("synonyms").split("|");
    var result = false;
    for(var syn in synonyms) {
      if(synonyms[syn].toLowerCase().indexOf(synonym.toLowerCase()) > -1) {
        result = synonyms[syn];
      }
    };
    return result;
  };

  countryFilter.prototype.filterListItems = function(filter) {
    var countryHeadings = $(".inner section.countries-wrapper div").children("h2"),
        listItems = $("ul.countries li"),
        itemsToHide,
        itemsShowing,
        synonymMatch = false,
        filterInst = this;

    this.filterHeadings(countryHeadings);
    listItems.each(function(i, item) {
      var $item = $(item);
      var link = $item.children("a");
      $item.html(link);
    }).show();

    filter = $.trim(filter);
    if(filter && filter.length > 0) {
      itemsToHide = listItems.filter(":not(:contains(" + filter + "))");
      itemsToHide.hide();
      itemsShowing = listItems.length - itemsToHide.length;
      listItems.each(function(i, item) {
        var $listItem = $(item);
        var synonym = filterInst.doesSynonymMatch(item, filter);
        if(synonym) {
          synonymMatch = true;
          $listItem.show().append("(" + synonym + ")");
        }
      });
      if(synonymMatch) {
        itemsShowing = listItems.find(":visible").length;
      }
      this.filterHeadings(countryHeadings);
    } else {
      countryHeadings.show();
      itemsShowing = listItems.length;
    }
    $(document).trigger("countrieslist", { "count" : itemsShowing });
  };

  countryFilter.prototype.updateCounter = function (e, eData) {
    var $counter = $(".country-count"),
        results;

    $counter.find(".js-filter-count").text(eData.count);
    $counter.html($counter.html().replace(/\sresults$/, ''));
    if (eData.count == 0) { // this is intentional type-conversion
      results = document.createTextNode(' results');
      $counter[0].appendChild(results);
    }
  };

  GOVUK.countryFilter = countryFilter;

  $("#country-filter form input#country").map(function(idx, input) { 
      new GOVUK.countryFilter($(input)); 
  });
}).call(this);
