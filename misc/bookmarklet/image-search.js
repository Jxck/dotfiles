javascript: ((e) => {
  /** image search **/
  let c,o,i,list = [];
  let imgs = e.getElementsByTagName('img');
  for (i = 0; i<imgs.length; i++) {
    list.push(imgs[i].parentNode.nodeName == 'A' ? imgs[i].parentNode.cloneNode(true) : imgs[i].cloneNode(false));
  }
  while(c = e.firstChild) e.removeChild(c);
  while(o = list.shift()) e.appendChild(o);
})(document.body);
