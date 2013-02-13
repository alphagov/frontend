(function ($) {
  jQuery.expr[':'].contains = function (obj, index, meta){
    return (obj.textContent || obj.innerText || "").toUpperCase().indexOf(meta[3].toUpperCase()) >= 0;
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
