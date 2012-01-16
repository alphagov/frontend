_gaq.push(['_trackEvent', 'Citizen-Format-Guide', 'Load']);
$(document).ready(function() {
  // click on link in guide
  $(".article-container a").click(function(){
    _gaq.push(['_trackEvent', 'Citizen-Format-Guide', 'Success-interaction']);
    return true;
  })
  
  // on a guide page for 10 seconds
  setTimeout("_gaq.push(['_trackEvent', 'Citizen-Format-Guide', 'Success-duration']);",10000);
});
