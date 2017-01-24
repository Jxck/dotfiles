// m3
javascript:location.href += '&tbs=qdr:m3'

// auto scroll
javascript:(function(){
  var interval = null;
  var time = 30;
  var len = 1;
  window.onclick = function() {
    if(interval === null) {
      interval = setInterval(function(){
        scrollBy(0, len);
      }, time);
    } else {
      clearInterval(interval);
      interval = null;
    }
  };
  window.onkeyup = function(e) {
    if (e.keyIdentifier === 'Down') {
      len *= 1.1;
    }
    if (e.keyIdentifier === 'Up') {
      len /= 1.1;
    }
  };
})();

// image search
javascript:(function(e){var c,o,i,list=[],imgs=e.getElementsByTagName('IMG');for(i=0;i<imgs.length;i++)list.push(imgs[i].parentNode.nodeName=='A' ? imgs[i].parentNode.cloneNode(true) : imgs[i].cloneNode(false));while(c=e.firstChild)e.removeChild(c);while(o=list.shift())e.appendChild(o)})(document.body);

// make header to link
javascript:var url = location.origin;Array.prototype.slice.call(document.querySelectorAll('h1, h2, h3, h4')).forEach(function($h) {  var $a = document.createElement('a');  $a.textContent = $h.textContent;  $h.textContent = '';  $a.href = url + '#' + $h.id;  $a.style.color = getComputedStyle($h).color;  $h.appendChild($a);});

// nico
javascript:$('#textMarquee').remove()
