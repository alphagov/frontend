_gaq.push(['_trackEvent', 'Citizen-Format-Benefit', 'Load']);
$(document).ready(function() {
  // click on link in benefit (programme)
  $(".article-container a").click(function(){
    _gaq.push(['_trackEvent', 'Citizen-Format-Benefit', 'Success-interaction']);
    return true;
  })
  
  // on a benefit (programme) page for 10 seconds
  setTimeout("_gaq.push(['_trackEvent', 'Citizen-Format-Benefit', 'Success-duration']);",10000);
});
