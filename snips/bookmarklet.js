// m3
javascript:location.href += '&tbs=qdr:m3'

// auto scroll
javascript:(() => {
  let interval = null;
  let time = 30;
  let len = 1;
  window.addEventListener('click', () => {
    if (interval === null) {
      interval = setInterval(() => {
        scrollBy(0, len);
      }, time);
    } else {
      clearInterval(interval);
      interval = null;
    }
  });
  window.addEventListener('keyup', (e) => {
    if (e.keyIdentifier === 'Down') {
      len *= 1.1;
    }
    if (e.keyIdentifier === 'Up') {
      len /= 1.1;
    }
  });
})();


// image search
javascript: ((e) => {
  let c,o,i,list = [];
  let imgs = e.getElementsByTagName('img');
  for (i = 0; i<imgs.length; i++) {
    list.push(imgs[i].parentNode.nodeName == 'A' ? imgs[i].parentNode.cloneNode(true) : imgs[i].cloneNode(false));
  }
  while(c = e.firstChild) e.removeChild(c);
  while(o = list.shift()) e.appendChild(o);
})(document.body);


// make header to link
javascript: (() => {
  let url = location.origin;
  let heders = document.querySelectorAll('h1, h2, h3, h4');
  Array.prototype.slice.call(headers).forEach(($h) => {
    let $a = document.createElement('a');
    $a.textContent = $h.textContent;
    $h.textContent = '';
    $a.href = url + '#' + $h.id;
    $a.style.color = getComputedStyle($h).color;
    $h.appendChild($a);
  });
})();


// nico
javascript:$('#textMarquee').remove()
