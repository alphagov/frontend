_gaq.push(['gwo._setAccount', 'UA-26179049-2']);
_gaq.push(['gwo._trackPageview', '/2185491999/test']);

function utmx_section(){}function utmx(){}
(function(){var k='2185491999',d=document,l=d.location,c=d.cookie;function f(n){
if(c){var i=c.indexOf(n+'=');if(i>-1){var j=c.indexOf(';',i);return escape(c.substring(i+n.
length+1,j<0?c.length:j))}}}var x=f('__utmx'),xx=f('__utmxx'),h=l.hash;

d.write('<sc'+'ript src="'+
'http'+(l.protocol=='https:'?'s://ssl':'://www')+'.google-analytics.com'
+'/siteopt.js?v=1&utmxkey='+k+'&utmx='+(x?x:'')+'&utmxx='+(xx?xx:'')+'&utmxtime='
+new Date().valueOf()+(h?'&utmxhash='+escape(h.substr(1)):'')+
'" type="text/javascript" charset="utf-8"></sc'+'ript>')})();

$(document).ready(function() {
  // click on 'get started' CTA
  $(".get-started a").click(function(){
      _gaq.push(['gwo._trackPageview', '/2185491999/goal']);
    return true;
  })
});

