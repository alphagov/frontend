_gaq.push(['_trackEvent', 'Citizen-Format-Service', 'Load']);
$(document).ready(function() {
  // click on 'get started' CTA
  $(".get-started a").click(function(){
    _gaq.push(['_trackEvent', 'Citizen-Format-Service', 'Success-interaction']);
    return true;
  })
  
});
