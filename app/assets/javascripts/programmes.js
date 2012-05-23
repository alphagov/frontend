$(function(){
  $('#wrapper').tabs();

  /* step link prompts */

  /* get all the sections */
  var sections = $(".tabs-panel"),
    i = sections.length,
    last = $(".tabs-panel:last").attr("id").split("-enhanced")[0],
    j,
    id,
    ul,
    navid,
    sectionTitle,
    nav;

    last = "<li><a href='#"+last+"'>No thanks, just tell me how to claim</a></li>"

  while(i--){
    j = i+1;
    id = $(sections[j]).attr("id");
    navid = id+"-nav";
    nav = $("<nav class='part-pagination group' role='navigation' id="+navid+"></nav>");
    ul = $("<ul></ul>");

    sectionTitle = $("#"+id+" h1").html();

    if(sectionTitle != undefined){
      sectionTitle = sectionTitle.toLowerCase();
      id = id.split("-enhanced")[0];
      var next = ("<li><a href='#"+id+"'>Read about "+sectionTitle+"</a></li>");
      if(i == 2){
        $(ul).append(next)
      }
      else{
        $(ul).append(next+last)
      }

      $(sections[i]).find(".inner").append(nav);
      $("#"+navid).append(ul);

      $(".part-pagination a").live("click", function(){
          // if this only links to a fragment ID and not a URL, we
          // consider it "safe" to scroll.
          if ($(this).attr('href').indexOf('#') === 0) {
              $("html, body").animate({scrollTop: $("#content").offset().top - 95}, 10);
          }
      });
    }
  }

});