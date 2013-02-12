(function ($) {
  jQuery.expr[':'].contains = function(a, i, m){
      return (a.textContent || a.innerText || "").toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
  };

  var input = $("form#country-filter input#country");
  var list = $("ul.countries li");

  $(input).change(function () {
    var filter = $(this).val();

    if (filter && filter.length > 0) {
      $(list).find("a:not(:contains(" + filter + "))").parent().hide();
      $(list).find("a:contains(" + filter + ")").parent().show();
    } else {
      $(list).find("a").parent().show();
    }

    return false;
  }).keyup(function () {
    $(this).change();
  });
}(jQuery));
